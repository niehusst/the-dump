---
layout: post
title:  "Committing to a git repo through the GitHub API"
background: "/assets/imgs/bikedump.jpg"
---

Git and GitHub are both incredibly ubiquitous tools for software engineers.
And in many automation adventures, you may find yourself wishing to programmatically
update code that lives in GitHub (at least I have).

Sometimes, this is as simple as using the git CLI in your automation shell script.
But other times, you may need to do it from your application code, or may want
a more ergonomic programming language than bash from which to make your changes.

In various projects over the years, I've used both GitHub's REST API and newer GraphQL API to commit automated changes and open pull requests. And it's not necessarily straighforward to accomplish this goal with either API due to a few gotchas in the inputs various endpoints expect.
So today, I thought I'd share some (likely) functional code to get you on the right path if you (or future me) is ever in need of this functionality.

All sample code uses the official octokit JS API client, since it's one of the only
first party API clients they support, and since it's what I used in my previous endeavors, from which I adapted the sample code.

The full samples can be found in my [github-api-examples github repo](https://github.com/niehusst/github-api-examples).

## Creating a new branch

Since my workflows revolved around creating PRs, I needed to create a new branch
every time the automation ran. But if you only need to push commits to an existing
branch, then you just need to get your target branch and can skip creating a new
branch off of it.

<table>
<tr>
<th> REST (cjs) </th>
<th> GraphQL (ts) </th>
</tr>
<tr>
<td>

<pre><code>
// get sha of base branch so we can branch off it for new branch
const { data: branchRefData } = await octo.git.getRef({
  owner,
  repo,
  ref: `heads/${base}`,
})
const baseBranchSha = branchRefData.object.sha

// create new branch to add changes to and make PR from
await octo.git.createRef({
  owner,
  repo,
  ref: `refs/heads/${newBranchName}`,
  sha: baseBranchSha,
});
</code></pre>

</td>
<td>

<pre><code>
  // get base branch head commit to branch off of
  const getHeadCommitQuery = `
    query ($repoOwner: String!, $repoName: String!, $refName: String!) {
      repository(owner: $repoOwner, name: $repoName) {
        ref(qualifiedName: $refName) {
          __typename
          id
          target {
            id
            oid
          }
        }
      }
    }
    `;
  const getHeadCommitParams: {
    repoName: Scalars["String"]["input"];
    repoOwner: Scalars["String"]["input"];
    refName: Scalars["String"]["input"];
  } = {
    repoName,
    repoOwner,
    refName: baseBranchName,
  };
  const headResp = await octokit.graphql<{
    repository: Query["repository"];
  }>(getHeadCommitQuery, getHeadCommitParams);
  const commitHead = headResp.repository?.ref?.target;

  // create the new branch
  const createBranchMutation = `
    mutation ($branchName: String!, $commitHeadId: GitObjectID!, $repoId: ID!) {
      createRef(
        input: { name: $branchName, oid: $commitHeadId, repositoryId: $repoId }
      ) {
        __typename
    
        ref {
            __typename
            id
            name
    
            target {
              id
              oid
            }
        }
      }
    }
  `;
  const createBranchParameters: {
    repoId: Scalars["ID"]["input"];
    branchName: Scalars["String"]["input"];
    commitHeadId: Scalars["GitObjectID"]["input"];
  } = {
    commitHeadId: commitHead.oid,
    branchName,
    repoId,
  };
  const branchResp = await octokit.graphql<{
    createRef: Mutation["createRef"];
  }>(createBranchMutation, createBranchParameters);
  const branch = branchResp.createRef?.ref;
</code></pre>

</td>
</tr>
</table>

## Making file changes

While making the file changes themselves can be done however you like, how you tell GitHub what those changes are involves sending the new file contents to their servers.
However, each API expects those file changes to be communicated in a different format.
The REST API expects a blob created from the file content, whereas the GraphQL API 
expects the file content base64 encoded.

<table>
<tr>
<th> REST (cjs) </th>
<th> GraphQL (ts) </th>
</tr>
<tr>
<td>

<pre><code>
// convert chosen files to commit into blobs for gh api
const filePaths = ['./relative/path/to/changed-file.js'];
const filesBlobs = await Promise.mapSeries(filesPaths, async (filePath) => {
  // create blob from content at each file path
  const content = await fs.readFile(filePath, 'utf8')
  const blobData = await octo.git.createBlob({
    owner,
    repo,
    content,
    encoding: 'utf-8',
  })
  return blobData.data
});

// put blobs into a new git tree so it can be committed
// https://git-scm.com/book/en/v2/Git-Internals-Git-Objects
const tree = filesBlobs.map(({ sha }, index) => ({
  path: filePaths[index],
  mode: '100644', // normal file mode; like chmod permissions
  type: 'blob',
  sha,
}))
const { data } = await octo.git.createTree({
  owner,
  repo,
  tree,
  base_tree: currentCommit.treeSha,
})
const newTree = data;
</code></pre>

</td>
<td>

<pre><code>
  // https://docs.github.com/en/graphql/reference/input-objects#filechanges
  const fileChanges = {
    "deletions": [
      {
        "path": "docs/README.txt",  // this will delete the whole file.
      }
    ],
    "additions": [
      {
        "path": "newdocs/README.txt",
        // replaces file at path with new contents
        "contents": Buffer.from("new file content\n").toString("base64")  
      }
    ]
  }
</code></pre>

</td>
</tr>
</table>

## Create a commit on the new branch

Now that we have our file changes converted to the proper input format, we can create a commit.
The GitHub APIs don't make a distinction between staged and pushed commits like the CLI does. So once you make this API call, your commit is created and "pushed" at the same time! If you don't need to make pull requests, your journey ends here.

<table>
<tr>
<th> REST (cjs) </th>
<th> GraphQL (ts) </th>
</tr>
<tr>
<td>

<pre><code>
const message = "My commit message"
const newCommit = (await octo.git.createCommit({
  owner,
  repo,
  message,
  tree: newTree.sha,
  parents: [currentCommit.commitSha],
})).data;

// add commit to target branch
await octo.git.updateRef({
  owner,
  repo,
  ref: `heads/${newBranchName}`,
  sha: newCommit.sha,
})
</code></pre>

</td>
<td>

<pre><code>
  const createCommitMutation = `
    mutation (
      $branch: CommittableBranch!
      $headOid: GitObjectID!
      $message: CommitMessage!
      $fileChanges: FileChanges!
    ) {
      createCommitOnBranch(
        input: {
          branch: $branch
          expectedHeadOid: $headOid
          message: $message
          fileChanges: $fileChanges
        }
      ) {
        __typename
    
        commit {
          id
          oid
    
        }
      }
    }
  `;
  const createCommitParameters: {
    branch: CommittableBranch;
    headOid: Scalars["GitObjectID"];
    message: CommitMessage;
    fileChanges: FileChanges;
  } = {
    branch: {
      branchName: branch.name,
      repositoryNameWithOwner: `${repoOwner}/${repoName}`,
    },
    headOid: branch.target!.oid,
    message: { headline: "Commit message here" },
    fileChanges,
  };
  const commitResp = await octokit.graphql<{
    createCommitOnBranch: Mutation["createCommitOnBranch"];
  }>(createCommitMutation, createCommitParameters);
</code></pre>

</td>
</tr>
</table>

## Opening a PR

Now that all the hard work of constructing a commit is out of the way, creating a PR
using either API is pretty simple.

<table>
<tr>
<th> REST (cjs) </th>
<th> GraphQL (ts) </th>
</tr>
<tr>
<td>

<pre><code>
await octo.pulls.create({
  owner,
  repo,
  base,
  head: newBranchName,
  title: 'This PR automated by code!',
  body: 'you're welcome',
  maintainer_can_modify: true,
  draft: false,
});
</code></pre>

</td>
<td>

<pre><code>
  const createPrMutation = `
    mutation (
      $baseRefName: String!
      $body: String!
      $headRefName: String!
      $repoId: ID!
      $title: String!
    ) {
      createPullRequest(
        input: {
          baseRefName: $baseRefName
          body: $body
          headRefName: $headRefName
          repositoryId: $repoId
          title: $title
        }
      ) {
        __typename
    
        pullRequest {
          __typename
          number
        }
      }
    }
  `;
  const createPrParameters: {
    baseRefName: Scalars["String"]["input"];
    body: Scalars["String"]["input"];
    headRefName: Scalars["String"]["input"];
    repoId: Scalars["ID"]["input"];
    title: Scalars["String"]["input"];
  } = {
    repoId,
    baseRefName: baseBranchName,
    headRefName: branch!.name,
    title: "this PR created by automation!",
    body: "you're welcome",
  };
  const prResp = await octokit.graphql<{
    createPullRequest: Mutation["createPullRequest"];
  }>(createPrMutation, createPrParameters);
</code></pre>

</td>
</tr>
</table>

And that's all there is to it! With this code (or at least this guide on what operations to look up) you should be able to programmatically commit code and open automated PRs in no time.

