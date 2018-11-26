#!python3

import os
import sys
import subprocess
import logging
from update_links import compute_relative_links


def create_logger(name, is_debug=False):
    """ simple wrapper to create a logger """
    log_level = logging.DEBUG if is_debug else logging.INFO
    # create logger
    logger = logging.getLogger(name)
    logger.setLevel(log_level)
    # create console handler
    ch = logging.StreamHandler()
    ch.setLevel(log_level)
    # create formatter and add it to handler
    formatter = logging.Formatter('%(asctime)s [%(name)s] %(levelname) 5s - %(message)s',
                                  datefmt='%H:%M:%S')
    ch.setFormatter(formatter)
    # add handler to logger
    logger.addHandler(ch)
    logger.debug('{} created'.format(str(logger)))
    return logger


def ls(directory):
    file_list = []
    if os.path.exists(directory):
        for root, dirs, files in os.walk(directory):
            for name in files:
                file_list.append(os.path.join(root, name))
    else:
        logger.warning('{} not found'.format(directory))
    return file_list


def process_file(file):
    if file != '.mdpp' and file.endswith('.mdpp'):
        filename = file[:-5]  # remove last 5 char => the .mdpp extension

        # let's use markdownPP PreProcessor
        bashCommand = 'markdown-pp {0}.mdpp -o {0}.md'.format(filename)
        process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
        output, error = process.communicate()
        if output:
            logger.info(output)
        if error:
            logger.warning(error)

        # we don't need mdpp file anymore
        if destruct_mode:
            os.remove('{0}.mdpp'.format(filename))
        logger.info('{}.md succesfully preprocessed'.format(filename))


if __name__ == '__main__':

    # logger
    logger = create_logger('mdpp_processor')

    # destroy unecessary files on CI environment
    destruct_mode = False
    if len(sys.argv) == 2:
        if sys.argv[1] == 'destruct_mode':
            logger.warning('destructive mode enabled - for CI environment')
            destruct_mode = True
        else:
            logger.warning('unknown mode [ {} ]'.format(sys.argv[1]))

    # first : process template files : to be included :)
    for template in ls('docs/template'):
        process_file(template)

    # then process all other files
    for doc in ls('docs'):
        # no need to re process templates
        if 'docs/template/' not in doc:
            process_file(doc)

    # then update links
    for md_doc_path in ls('docs'):
        compute_relative_links(md_doc_path, logger=logger)

    # destroy templates : they are not needed anymore
    if destruct_mode:
        for file in ls('docs/template'):
            os.remove(file)
            logger.info('{} removed'.format(file))
