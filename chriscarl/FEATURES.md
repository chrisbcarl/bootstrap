# Features
Features are a way to "link" ideas together across multiple files. For example, say you commit a change called "FEATURE: xxx" but it affected your settings, a gitignore, a python file, and a data file. Wouldnt it be nice to be able to ctrl + f through the code, and see every affected location to refresh yourself? Functions as a light TODO file.

## Usage
- as an architect
    1. define your types (can be anything)
    2. define the commit convention
- as a developer
    1. propose a feature in [#Dev](#dev)
    2. branch off
    3. put the feature under [#Stage](#stage) and modify as you see fit
    4. commit some code, ideally using the text like `- FEATURE: xxx` as the entire commit message (for example adding a dash so it will display as a list). people can lookup what you meant in this file or by searching (and they'll get this file anyway)
- as a maintainer
    1. on merge branch
    2. move all of the features under [#Stage](#stage) into [#Prod](#Prod)
        - modify versions
        - modify dates


# Types:
- `FEATURE`: a multi-algorithm thing that emerges as a "feature" you can brag about
- `FIX`: some bug that requires fixing
- `FILE`: some file


# Dev
|version |author |deployed |created |feature-name |description |
--- | --- | --- | --- | --- | ---
|0.~0~.~0~|author|20xx-yy-zz|20xx-yy-zz|`FEATURE: xxx`|whatever|


# Stage
|version |author |deployed |created |feature-name |description |
--- | --- | --- | --- | --- | ---


# Prod
|version |author |deployed |created |feature-name |description |
--- | --- | --- | --- | --- | ---
|0.0.0|chriscarl|2025-01-24|2025-01-24|`FEATURE: ipynb-matplotlib-widgets`|added %matplotlib widgets and all of the requirements to hit it|
|0.0.0|chriscarl|2025-01-24|2025-01-24|`FEATURE: chriscarl-features`|added the features file|