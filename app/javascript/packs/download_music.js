import { v4 as uuidv4 } from 'uuid';
import 'channels/download_music_channel';

$(document).ready(function() {
  $('#download_music_form').submit(function(event){
    event.preventDefault();
    var base_url = event.target.action;
    var uuid = '?uuid=' + uuidv4();
    var youtube_url = '&youtube_url=' + $('#youtube_url').val();
    var url = base_url + uuid + youtube_url


    function subscribeDownloadChannel(uuid, callback) {
      App.download = App.cable.subscriptions.create(
        { channel: "DownloadMusicChannel", uuid: uuid },
        {
          connected: function() {
            callback();
          },

          disconnected: function() {},

          received: function(data) {
            console.log(data)
            var blob = new Blob([data.music], {
              type: data.content_type
            });

            saveAs(blob, data.file_name);

            $("#download_musics")
              .html("Download Musics")
              .removeAttr("disabled");

            App.download.unsubscribe();
            App.cable.disconnect();
            delete App.download;
          }
        }
      );
    }

    subscribeDownloadChannel(uuid, function() {
      $.get(url);
    });

    return false;
  });
});

// $('#download_books').click(function(e) {
//   e.preventDefault();
//   var uuid = generateUUID();
//   $(this).html('Downloading...').attr('disabled', 'disabled');
//   var url = $(this).attr('href') + '?uuid=' + uuid;
//   subscribeDownloadChannel(uuid, function() {
//     $.get(url);
//   });
//   return false;
// })
