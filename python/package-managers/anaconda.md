# creating a reproducible environment
1. update conda
    ```powershell
    # open administrator, though it shouldnt need to
    conda install python=3.12.6
    conda config --describe verbosity
    $env:CONDA_VERBOSITY = 2 # conda debug, default 0 warnings
    $env:CONDA_VERBOSITY = 1 # conda info, default 0 warnings
    conda update -n base -c conda-forge conda -y
    ```
2. generate new env
    ```powershell
    conda create --name gensim  python=3.10 -y
    conda activate gensim
    ```
3. install some dependencies
    ```powershell
    # may not be necessary
    conda config --add channels defaults  # stack, so filo
    conda config --add channels pytorch
    conda config --add channels conda-forge
    conda config --set channel_priority flexible
    # takes not a LOT of time if using modern solver > 23.10
    # https://conda.github.io/conda-libmamba-solver/user-guide/
    conda install jupyterlab notebook ipywidgets ipympl pandas scipy nltk keras seaborn plotly xgboost imbalanced-learn tensorflow spacy gensim unidecode lxml -y
    ```
4. export
    ```powershell
    conda export > gensim.yaml
    ```


# create
```powershell
conda env create --name "new-env" --file=C:\Users\chris\src\pgp-aiml\gensim.yaml  # must be -f, not --file
```


# remove
```powershell
conda deactivate  # if youre currently in the env
conda remove --name ENV_NAME --all -y
```
