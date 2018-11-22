#!python3

import os
import re


def splitall(path):
    # thanks oreilly
    # https://www.oreilly.com/library/view/python-cookbook/0596001673/ch04s16.html
    allparts = []
    while 1:
        parts = os.path.split(path)
        if parts[0] == path:  # sentinel for absolute paths
            allparts.insert(0, parts[0])
            break
        elif parts[1] == path:  # sentinel for relative paths
            allparts.insert(0, parts[1])
            break
        else:
            path = parts[0]
            allparts.insert(0, parts[1])
    return allparts


def replace_relative_links_for_line(line, nb_up, logger):
        re_link = r'\[[^\]]*\]\((.*)(?=\"|\))(\".*\")?\)'
        re_image = r'!' + re_link

        if '{./.}' in line:
            # process_images
            if re.search(re_image, line):
                if logger:
                    logger.debug('image : {}'.format(line))
                line = line.replace('{./.}', '../' * (nb_up - 2))

            # process links
            elif re.search(re_link, line):
                if logger:
                    logger.debug('link : {}'.format(line))
                line = line.replace('{./.}', '../' * (nb_up - 1))

        return line


def compute_relative_links(file_path, logger=False):

    if file_path != '.md' and file_path.endswith('.md'):
        splitted = splitall(file_path)
        if logger:
            logger.debug(splitted)
        nb_up = len(splitted)
        new_lines = []

        # Read file and throw updates to memory
        with open(file_path, 'r') as old_file:
            for line in old_file:
                new_lines.append(
                    replace_relative_links_for_line(line, nb_up, logger)
                )
        # Erase file with new contents
        with open(file_path, 'w') as new_file:
            new_file.writelines(new_lines)
