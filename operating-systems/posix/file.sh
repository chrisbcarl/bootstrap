man file  # command tests each argument and outputs what kind of file it thinks it is, accepts wildcards or lists

file dummy_id_file  *
# dummy_id_file:    ASCII text, with no line terminators
# AnacondaProjects: directory
# Documents:        directory
# R:                directory
# cdssetup:         directory
# dummy_id_file:    ASCII text, with no line terminators
# enved.jrl:        ASCII text, with CRLF line terminators
# pcbenv:           directory

file $(ls)
