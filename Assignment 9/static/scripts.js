/**
 * Assignment 9 
 */

/** Load the list of albums */
function listAlbums() {
    const albumList = $('#albums_list');
    const listFactory = (id, artist, name) => {
        const link = $(`<a href="#">${artist} - ${name}</a>`);
        link.click(() => {
            showAlbum(id);
        });
        return $('<li></li>').append(link);
    }

    $.get('/albums', (data) => {
        albumList.empty();
        const albums = JSON.parse(data);
        for (const id in albums) {
            const album = albums[id];
            albumList.append(listFactory(album.id, album.artist, album.name));
        }
    });
}

/** Show details of a given album */
function showAlbum(album_id) {
    $.get(`/albuminfo?album_id=${album_id}`, (data) =>{
        const album = JSON.parse(data);
        const cover = $('#album_cover');
        cover.empty();
        cover.append($(`<img src="/static/images/${album.image}"/>`));

        const song_view = $('<table></table>');
        song_view.append(`
        <tr>
            <th>No.</th>
            <th>Title</th>
            <th>Length</th>
        </tr>
    `);

    const song_factory = (id, name, length) => $(`
        <tr>
            <td class="song_no">${id}.</td>
            <td class="song_title">${name}</td>
            <td class="song_length">${length}</td>
        </tr>
    `);
    var total = 0
    album.tracks.forEach((track, index) => {
        const tableRow = song_factory(index + 1, track.name, track.length);
        song_view.append(tableRow);
        var length = track.length.split(":");
        total += (+length[0]) * 60 + (+length[1]);
    });
    
    var date = new Date(1970,0,1)
    date.setSeconds(total);
    var totalLength = date.toTimeString().replace(/.*(\d{2}:\d{2}:\d{2}).*/, "$1");
    const row = (`
        <tr>
            <td class="album_total_text" colspan="2" >Total Length</td>
            <td class="album_length">${totalLength}</td>
        </tr>
    `);
    song_view.append(row);

    const songs = $('#album_songs');
    songs.empty();
    songs.append(song_view);
    })
}

$(() => {
    listAlbums();
});