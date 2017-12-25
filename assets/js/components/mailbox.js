import React from "react"
import {Mail} from "./mail"

export default class MailBox extends React.Component {
    constructor(props) {
        super(props);
        this.state = {mail: []}
        this.onMail = this.onMail.bind(this);
    }

    onMail(mail) {
        this.state.mail.push(mail);
    }

    componentDidMount() {
        const channel = this.props;
        channel.join()
          .receive("ok", resp => { console.log("Joined successfully", resp) })
          .receive("error", resp => { console.log("Unable to join", resp) });

        channel.on("new_mail", payload => {
            this.onMail(payload.data);
        });

        channel.on("end_session", payload => {
            console.log("terminating session");
            channel.leave();
        });
    }

    render() {
        return <Mail mail={this.state} />;
    }
}
