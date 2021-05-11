import React, {Component} from 'react'
import axios from 'axios'

class PostList extends Component {
    constructor(props) {
        super(props)

        this.state = {
            posts: []
        }
    }

    componentDidMount() {
        axios.get('https://jsonplaceholder.typicode.com/posts')
        .then(Response => {
            console.log(Response)
        })
        .catch(error => {
            console.log(error)
        })
    }

    render() {
        return (
            <div>
                list of posts
            </div>
        )
    }
}

export default PostList