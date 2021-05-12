import React, {Component} from 'react'
import axios from 'axios'

class PostList extends Component {
    constructor(props) {
        super(props)

        this.state = {
            shipments: []
        }
    }

    componentDidMount() {
        axios.get(`http://localhost:8080/shipments`)
        .then(response => {
            console.log(response)
            this.setState({shipments: response.data})
        })
        .catch(error => {
            console.log(error)
        })
    }

    render() {
        const { shipments } = this.state
        console.log(shipments)
        console.log(shipments.length)
        const shipment = shipments[0]
        console.log(shipment)
        console.log(shipments.id)
        return (
            <span>
                list of posts
                {
                    shipments.length   ?
                    shipments.map(shipments => <div key={shipments.id}>{shipments.titel}</div>):
                    null
                }

            </span>
        )
    }
}

export default PostList