import consumer from "./consumer"
import { v4 as uuidv4 } from 'uuid';

$(document).ready(function () {
  const downloadMusicChannel = consumer.subscriptions.create({ channel: "DownloadMusicChannel", uuid: uuidv4() } , {
    connected() {
      console.log('Connected')
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data);

      var element = document.createElement('a');
      element.setAttribute('href', data.music_url);
      element.setAttribute('download', data.music_name);
      element.style.display = 'none';
      document.body.appendChild(element);

      element.click();

      console.log(element);
      document.body.removeChild(element);
    }
  });

  $('#download_music_form').submit(function(event){
    event.preventDefault();
    downloadMusicChannel.send({ youtube_url: $('#youtube_url_text_field').val() });
  });
});
