"""Function that deletes some files from the directory."""
import os


def delete_file(file_path):
    
    if os.path.isfile(file_path):
        os.remove(file_path)
        print("File "+file_path+" has been deleted")
    else:
        print("File "+file_path+" does not exist")


def delete_files():
    delete_file('Commands.tcl')
    delete_file('command.tcl')
