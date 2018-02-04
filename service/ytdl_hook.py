from youtube_dl import YoutubeDL

ydl = YoutubeDL(params={'quiet': True, 'noplaylist': True})


def get_info_for(url):
    selector = ydl.build_format_selector('best[ext=mp4]')
    info = ydl.extract_info(url, download=False)
    ours, = selector({
        'formats': info['formats'],
    })
    return ours

if __name__ == '__main__':
    import json
    from sys import argv
    print(json.dumps(get_info_for(argv[-1]), indent=2))
