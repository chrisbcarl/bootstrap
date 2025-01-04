jupyter nbconvert --to html mynotebook.ipynb
jupyter nbconvert --to latex mynotebook.ipynb
jupyter nbconvert --to html --template lab mynotebook.ipynb
jupyter nbconvert --to pdf mynotebook.ipynb
jupyter nbconvert --to slides --post serve myslides.ipynb

# --output=<Unicode>
#     Overwrite base name use for output files.
#                 Supports pattern replacements '{notebook_name}'.
#     Default: '{notebook_name}'
#     Equivalent to: [--NbConvertApp.output_base]
# --output-dir=<Unicode>
#     Directory to write output(s) to. Defaults
#                                   to output to the directory of each notebook. To recover
#                                   previous default behaviour (outputting to the current
#                                   working directory) use . as the flag value.
#     Default: ''
#     Equivalent to: [--FilesWriter.build_directory]
