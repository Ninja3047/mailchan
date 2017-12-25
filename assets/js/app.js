// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import {Socket} from "phoenix"

import React from "react"
import ReactDOM from "react-dom"
import {MailBox} from "./components/mailbox"

window.getCookie = (name) => {
    let match = document.cookie.match(new RegExp(name + '=([^;]+)'));
    return match ? match[1] : null;
};

let socket = new Socket("/mail", {params: {token: window.userToken}});
socket.connect();

let channel = socket.channel("mail:" + window.getCookie("mail_id"), {});
ReactDOM.render(<MailBox channel={channel} />, document.getElementById('emails'));
