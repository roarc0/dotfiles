#!/usr/bin/env python3
import os
import sys
import json
import logging
from gi.repository import Gio
from argparse import ArgumentParser

logging.basicConfig()
logging.root.setLevel(logging.NOTSET)
logging.basicConfig(level=logging.NOTSET)
log = logging.getLogger("iconize")

homedir = os.environ['HOME'] + '/'
icondir = os.environ['ENV_HOME'] + '/dotfiles/local/share/icons/'
configfile = os.environ['ENV_HOME'] + '/dotfiles/local/share/icons.json'


def check_params(fpath, ipath):
    if not fpath.startswith('/'):
        fpath = homedir + fpath
    if not ipath.startswith('/'):
        ipath = icondir + ipath

    if not ipath.endswith(('.svg', '.png')):
        if os.path.exists(ipath + '.svg'):
            ipath += '.svg'
        elif os.path.exists(ipath + '.png'):
            ipath += '.png'

    if not os.path.exists(ipath):
        log.info("icon " + ipath + " does not exist")
        return (None, None)

    if not os.path.exists(fpath):
        log.info("path " + fpath + " does not exist")
        return (None, None)

    return (fpath, ipath)


def set_icon(fpath, ipath):
    (fpath, ipath) = check_params(fpath, ipath)
    log.info('setting icon ' + ipath + ' to ' + fpath)
    if fpath is None:
        return False
    folder = Gio.File.new_for_path(fpath)
    icon = Gio.File.new_for_path(ipath)
    CUSTOM_ICON = 'metadata::custom-icon'
    info = folder.query_info(CUSTOM_ICON, 0, None)
    if icon is not None:
        icon_uri = icon.get_uri()
        info.set_attribute_string(CUSTOM_ICON, icon_uri)
    else:
        info.set_attribute(CUSTOM_ICON,  Gio.FileAttributeType.INVALID, '')
    folder.set_attributes_from_info(info, 0, None)
    return True


def load_db(filename):
    if not os.path.exists(filename):
        create_db()
    with open(filename) as f:
        data = json.load(f)
    return data


def save_db(filename, data):
    with open(filename, "w") as f:
        f.write(json.dumps(data, indent=4, sort_keys=True))


def create_db():
    config = {}
    config['folders'] = []
    save_db(configfile, config)


def add_icon(fpath, ipath):
    del_icon(fpath)
    print('adding icon ' + ipath + ' to ' + fpath)
    data = load_db(configfile)
    data['folders'].append({'path': fpath, 'icon': ipath})
    save_db(configfile, data)


def del_icon(fpath):
    data = load_db(configfile)
    elems = [elem for elem in data['folders'] if elem['path'] == fpath]
    for elem in elems:
        log.info('removing icon from ' + fpath)
        data['folders'].remove(elem)
    save_db(configfile, data)


def do_add(args):
    fpath = args.fpath
    if fpath.startswith(homedir):
        fpath = fpath[len(homedir):]

    add_icon(fpath, args.ipath)
    set_icon(fpath, icondir + args.ipath)


def do_del(args):
    del_icon(args.fpath)


def do_set(args):
    log.info('loading conf: ' + configfile)
    data = load_db(configfile)
    for folder in data['folders']:
        if not set_icon(folder['path'], folder['icon']):
            print('setting icon has failed')


def main():
    parser = ArgumentParser()
    parser.add_argument("-f", "--folder", dest="fpath", default="",
                        help="folder path", metavar="FILE")
    parser.add_argument("-i", "--icon", dest="ipath", default="",
                        help="icon name")
    parser.add_argument("-C", "--config", dest="config", default='config.json',
                        help="config", metavar="FILE")
    parser.add_argument("-a", "--action", dest="action", default='set',
                        help="[set, add]")
    args = parser.parse_args()

    if args.fpath and args.action == 'set':
        args.action = 'add'

    try:
        globals()[f'do_{args.action}'](args)
    except Exception as e:
        log.info('error executing action: ' + str(e))
        sys.exit(1)


if __name__ == '__main__':
    main()
