"""
Assignment #9: AJAX
"""

from flask import Flask, request, g
import json
import csv
import jsonpickle
import datetime

app = Flask(__name__)


class Track():
    """Class representing a track"""

    def __init__(self, album_id, name, length):
        self.album_id = album_id
        self.name = name
        self.length = length

    def get_album_id(self):
        return self.album_id

    def get_name(self):
        return self.name

    def get_lengt(self):
        return self.length


class Album():
    """Class representing an album"""

    def __init__(self, id, artist, name, image):
        self.id = id
        self.artist = artist
        self.name = name
        self.image = image
        self.tracks = []

    def get_id(self):
        return self.id

    def get_atist(self):
        return self.artist

    def get_name(self):
        return self.name

    def get_image(self):
        return self.image

    def get_tracks(self):
        return self.tracks

    def add_track(self, track):
        self.tracks.append(track)


class Albums():
    """Class representing a collection of albums."""

    def __init__(self, albums_file, tracks_file):
        self.__albums = {}
        self.__load_albums(albums_file)
        self.__load_tracks(tracks_file)

    def __load_albums(self, albums_file):
        """Loads a list of albums from a file."""
        with open(albums_file) as file:
            for line in csv.reader(file, dialect="excel-tab"):
                id = line[0]
                artist = line[1]
                name = line[2]
                image = line[3]
                album = Album(id, artist, name, image)
                self.__albums[id] = album

    def __load_tracks(self, tracks_file):
        """Loads a list of tracks from a file."""
        with open(tracks_file) as file:
            for line in csv.reader(file, dialect="excel-tab"):
                album_id = line[0]
                track_name = line[1]
                track_length = line[2]
                track = Track(album_id, track_name, track_length)
                if self.__albums[album_id]:
                    self.__albums[album_id].add_track(track)

    def get_albums(self):
        """Returns a list of all albums, with album_id, artist and title."""
        return self.__albums

    def get_album(self, album_id):
        """Returns all details of an album."""
        self.__albums[album_id].get_total
        return self.__albums[album_id]


# the Albums class is instantiated and stored in a config variable
# it's not the cleanest thing ever, but makes sure that the we load the text files only once
app.config["albums"] = Albums("data/albums.txt", "data/tracks.txt")


@app.route("/albums")
def albums():
    """Returns a list of albums (with album_id, author, and title) in JSON."""
    albums = app.config["albums"]
    return jsonpickle.encode(albums.get_albums(), unpicklable=False, make_refs=False)


@app.route("/albuminfo")
def albuminfo():
    albums = app.config["albums"]
    album_id = request.args.get("album_id", None)
    if album_id:
        album = albums.get_album(album_id)
        return jsonpickle.encode(album, unpicklable=False, make_refs=False)
    return ""


@app.route("/sample")
def sample():
    return app.send_static_file("index_static.html")


@app.route("/")
def index():
    return app.send_static_file("index.html")


if __name__ == "__main__":
    app.run()
