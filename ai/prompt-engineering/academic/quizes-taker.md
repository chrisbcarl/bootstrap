# Quiz Taker Request
In the context of an ~~undergraduate operating systems course~~, evaluate the uploaded file. Extract, deduplicate, then answer the questions using the following rules:
1. Questions that only ask for acronym definition should be formatted in a single markdown table like the example markdown table provided in `### Acronyms`.
2. Questions that only ask for term definitions should be formatted in a single markdown table like the example markdown table provided in `### Definitions`.
3. Fill in the blank questions should be formatted in an ordered list using backtick escaped underscores like the examples provided in `### Fill In the Blank`.
4. Multiple choice should be formatted in an ordered list with bulleted choices like the examples provided in `### Multiple Choice`.
4. Essays or long-form response should be formatted using ordered subheaders using 4 octothorps like the examples provided in `### Essay`.

## Important
- Create 1 output file: a downloadable Markdown file containing the formatted questions and answers.
    - the file should contain the same structure order as the rules with the same headings depth.
- Explanations should be concise. Do not over-explain or over-elaberate per answer.
- `{model-vendor} {model-product} {model-version} {model-extended-or-standard-thinking}` should be replaced by an appropriate description of the currently running LLM. Examples include `Google Gemini 3.1 Pro`, `Anthropic Opus 4.7 Adaptive`, `OpenAI ChatGPT 5.5 Thinking Extended`.


### Acronyms

- `{model-vendor} {model-product} {model-version} {model-extended-or-standard-thinking}`

|acronym|meaning           |
|---    |---               |
|ABC    |Alpha Beta Charlie|
|DEF    |Delta Echo Foxtrot|
|GHI    |Golf Hotel Indigo |
|XYZ    |X-ray Yankee Zulu |

### Definitions

- `{model-vendor} {model-product} {model-version} {model-extended-or-standard-thinking}`

|term     |definition                |
|---      |---                       |
|Life     |The result of living      |
|Liberty  |Freedom from and fredom to|
|Happiness|Self-actualization        |

### Fill In the Blank

- `{model-vendor} {model-product} {model-version} {model-extended-or-standard-thinking}`

1. Question text that used underscores for the blank should use <u>underline</u> for the answer.
    - other options include: {explain-other-options}
2. A second fill in the <u>blank</u>.
    - other options include: {explain-other-options}

### Multiple Choice

- `{model-vendor} {model-product} {model-version} {model-extended-or-standard-thinking}`

1. A multiple choice question should be responded to in-line.
    - (a) `[ ]` A only;
    - (b) `[ ]` B only;
    - (c) `[x]` A and B;
    - (d) `[ ]` something else;
    - reasoning: {explain-reasoning}
2. A multi-choice multiple choice question.
    - (a) `[ ]` A only;
    - (b) `[ ]` B only;
    - (c) `[x]` A and B;
    - (d) `[x]` something else;
    - reasoning: {explain-reasoning}

### Essay

#### 1: Question Topic
An essay type question with the prompt here.

$$
\text{Any } \LaTeX \text{ formulas used in the question prompt.}
$$

```python
# any code used in the question prompt
```

- `{model-vendor} {model-product} {model-version} {model-extended-or-standard-thinking}`

    {answer-line-1}

    {answer-line-2}

    ...

#### 2: Another Question Topic
An essay type question with the prompt here.

$$
\text{Any } \LaTeX \text{ formulas used in the question prompt.}
$$

```python
# any code used in the question prompt
```

- `{model-vendor} {model-product} {model-version} {model-extended-or-standard-thinking}`

    {answer-line-1}

    {answer-line-2}

    ...
