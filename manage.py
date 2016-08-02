"""
The protocol is described here:
http://www.gutenberg.org/wiki/Gutenberg:Information_About_Robot_Access_to_our_Pages
"""
import argparse

from downloader.crawler import GutenbergCrawler
from downloader.archivemanager import FolderItemsUnzipper
from downloader import FileDownloader
import settings

def file_list(download_urls, out_path):
    with open(out_path, 'w') as out:
        for url in download_urls:
            print(url, file=out)

def main(args):
    print('START.')
    crawler = GutenbergCrawler(args.file_type, args.n_ebooks, args.lang)
    crawler.run()
    if args.file_list:
        file_list(crawler.download_urls, args.file_list)
    else:
        downloader = FileDownloader(crawler.download_urls, settings.STORAGE_PATH)
        downloader.run()
        unzipper = FolderItemsUnzipper(settings.STORAGE_PATH)
        unzipper.run()
    print('END.')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Downloads free ebooks from Project Gutenberg.')
    parser.add_argument('--file-type',
                        choices=['txt', 'pdf', 'html', 'epub.images', 'epub.noimages',
                                 'kindle.images', 'kindle.noimages', 'mp3'],
                        help='Filter by file types.', action='append')
    parser.add_argument("--file-list", type=str, help='Rather than downloading files, output list of files to download.')
    parser.add_argument('--lang', type=str,
                        help='Ebook language.', action='append')
    parser.add_argument('--n-ebooks', type=int, default=100,
                        help='Number of ebooks to download (default: 100).')
    args = parser.parse_args()
    main(args)
