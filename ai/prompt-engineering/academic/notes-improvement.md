The `# Notes` header contains a summary of topics discussed in an ~~undergraduate operating systems~~ course. For each topic posed:

1. Is the provided summary or definition correct? If it is not, what is the correct summary or definition?
2. Can the provided summary or definition be improved with better conciseness, more clarity, or illustrative formatting?

Create 2 markdown files as output and 1 zip file as output. The first file contains the improved notes. The second file contains the justification for the improvements. Both markdown files should have an HTML comment with the information templated specified under the `# Meta` header. If diagrams are generated, archive all of the generated images to a .zip file and keep the references in the output markdown files relative to the same directory.

The justification file should order the corrections with the following headers: "Incorrect" which describes where the issue is using strikethrough or comments on lines containing bugs, "Misunderstood" which does the same as Incorrect and adds why the new text or code is better, and "Fine As-Is" describing the topic that was skipped for refinement.

The zip file should contain all contents in `/mnt`, `/tmp` and `/content` if those folders exist. As a fallback, after .zip creation, output the base64 encode of the created .zip file in the chat output so that its contents can be deserialized later.

# Meta
date:         <date>
developer:    <model-developer>
model:        <model>
version:      <model-version>
extended:     <model-extended-or-standard-thinking>
elapsed:      <session-elapsed-time-in-HH:MM:SS-format>
url:          <url-of-chat>


# Notes