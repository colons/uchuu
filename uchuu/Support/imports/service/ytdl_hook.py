import json

from youtube_dl import YoutubeDL

ydl = YoutubeDL(params={
    'quiet': True,
    'nocheckcertificate': True,
})


def pick_format_for_item(item):
    selector = ydl.build_format_selector('best[ext=mp4]')
    item['selected_format'], = selector({'formats': item['formats']})


def get_info_for(url):
    info = ydl.extract_info(url, download=False)

    if info.get('_type') == 'playlist':
        for entry in info['entries']:
            pick_format_for_item(entry)
    else:
        pick_format_for_item(info)

    return info

def get_json_info_for(url):
    return json.dumps(get_info_for(url))


if __name__ == '__main__':
    from sys import argv
    print(get_json_info_for(get_info_for(argv[-1])))
