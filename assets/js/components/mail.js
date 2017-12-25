import React from "react"

export default class Mail extends React.Component {
    render() {
        const emails = this.props.mail.map( (mail) =>
            <li>{mail}</li>
        );
        return <ul>{emails}</ul>;
    }
}
