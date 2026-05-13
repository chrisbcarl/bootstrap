# Quiz Maker Request
In the context of an ~~undergraduate operating systems course~~, evaluate the uploaded files. Extract, deduplicate, then reformat the questions using the following rules:
1. Questions that only ask for acronym definition should be formatted in a single markdown table like the example markdown table provided in `### Acronyms`.
2. Questions that only ask for term definitions should be formatted in a single markdown table like the example markdown table provided in `### Definitions`.
3. Fill in the blank questions should be formatted in an ordered list using backtick escaped underscores like the examples provided in `### Fill In the Blank`.
4. Multiple choice should be formatted in an ordered list with bulleted choices like the examples provided in `### Multiple Choice`.
5. Essays or long-form response should be formatted using ordered subheaders using 4 octothorps like the examples provided in `### Essay`.

## Important
- Create 1 output file: a downloadable Markdown file containing the reformatted questions.
    - the file should contain the same structure order as the rules with the same headings depth.
- Deduplicate the questions (if there are any) keeping questions that change numbers or order of the request intact.
- Do not answer the questions--only extract and convert the original questions and reformat them as described in the rules and examples.


### Acronyms

|acronym|meaning           |
|---    |---               |
|ABC    |                  |
|DEF    |                  |
|GHI    |                  |
|XYZ    |                  |

### Definitions

|term     |definition                |
|---      |---                       |
|Life     |                          |
|Liberty  |                          |
|Happiness|                          |

### Fill In the Blank

1. Question text with `______` used for the blank.
2. A second fill in the `______`.

### Multiple Choice

1. A multiple choice question should be responded to in-line.
    - (a) `[ ]` A only;
    - (b) `[ ]` B only;
    - (c) `[ ]` A and B;
    - (d) `[ ]` something else;
2. A multi-choice multiple choice question.
    - (a) `[ ]` A only;
    - (b) `[ ]` B only;
    - (c) `[ ]` A and B;
    - (d) `[ ]` something else;

### Essay

#### 1: Question Topic
An essay type question with the prompt here.

$$
\text{Any } \LaTeX \text{ formulas used in the question prompt.}
$$

```python
# any code used in the question prompt
```

#### 2: Another Question Topic
An essay type question with the prompt here.

$$
\text{Any } \LaTeX \text{ formulas used in the question prompt.}
$$

```python
# any code used in the question prompt
```
