import { Button, Nav, NavRow, Row, Col, Card, Form } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Link, useHistory, useLocation, NavLink } from 'react-router-dom';
import { useState } from 'react';
import { delete_forumcomment, create_forumcomment, fetch_forumcomments, delete_forum, fetch_forum_score, fetch_forums,
  fetch_forum, fetch_user, update_forum_vote } from '../api';
import store from '../store';

function ForumView({session, forum_form, user_form, forum_score, forumcomments}) {
  let location = useLocation()
  let history = useHistory()
  let forum_id = location.pathname.split("/forum/view/")[1]

  if(typeof(forum_form.id) == "undefined" || forum_form.id != forum_id) {
    fetch_forums()
    fetch_forum(forum_id)
    fetch_forum_score(forum_id)
    fetch_forumcomments(forum_id)
  }

  if(typeof(user_form.id) == "undefined" || user_form.id != forum_form.user_id){
    fetch_forums()
    fetch_user(forum_form.user_id)
  }

  function photo_path(hash) {
    return "http://localhost:4000/photos/" + hash;
  }

  function deleteForum(){
    delete_forum(forum_id)
    fetch_forums()
    history.push("/forum/list")
  }

  function AddButtons() {
    if(session && session.user_id == user_form.id) {
      let link = "/forum/edit/" + forum_form.id
      return(
        <div>
        <Link to={link} className="btn mt-2 btn-lg btn-info text-light mr-2 font-weight-bold">Edit</Link>
        <Button onClick={deleteForum} className="btn mt-2 btn-lg btn-danger text-light mr-2 font-weight-bold">Delete</Button>
        <Link to="/forum/list" className="btn btn-lg mt-2 btn-info text-light  font-weight-bold">Back</Link>
        </div>
      )
    }
    else {
      return(
        <Link to="/forum/list" className="btn btn-lg mt-2 btn-danger text-light  font-weight-bold">Back</Link>
      )
    }
  }

  let link = photo_path(forum_form.photo_hash)

  function updateVotes() {
    if(forum_form.votes.includes(session.user_id)) {
      update_forum_vote(forum_form, session.user_id, "decrease")
      fetch_forums()
      fetch_forum(forum_form.id)
      fetch_forum_score(forum_form.id)
    }
    else {
      update_forum_vote(forum_form, session.user_id, "increase")
      fetch_forums()
      fetch_forum(forum_form.id)
      fetch_forum_score(forum_form.id)
    }
  }

  function photo_path(hash) {
    return "http://localhost:4000/photos/" + hash;
  }

  function EditCommentButton({comment}) {
    function deleteComment() {
      delete_forumcomment(comment.id, forum_id)
    }

    if (session && comment.user_id == session.user_id) {
      return <Button onClick={deleteComment} className="btn mt-2 btn-danger text-light font-weight-bold">Delete</Button>
    }
    else {
      return <div></div>
    }
  }

  function ListingComments() {
    let rows = forumcomments.map((comment) => {
      console.log(comment)
      return (
        <Card fluid className="my-4">
          <Card.Body>
            <img src={photo_path(comment.user.photo_hash)} width="50px" height="50px"></img>
            <h4 className="text-secondary">{comment.user.name}</h4>
            <h3 className="">{comment.body}</h3>
            <EditCommentButton comment={comment}/>
          </Card.Body>
        </Card>
      )})
      return <div>{rows}</div>
    }

    const [com, setCom] = useState("");

    function onSubmit(ev) {
      create_forumcomment(com, session.user_id, forum_id).then((data) => {
          if(data.error) {
            let action={
              type:"error/set",
              data: data.error
            }
            store.dispatch(action)
          }
          else {
            setCom("")
            fetch_forumcomments(forum_id)
            fetch_forums()
          }
      });
    }

    if (session) {
      return(
        <div>
        <AddButtons/>
        <h1 className="display-3">{forum_form.title}</h1>
        <h1 className="h4 text-secondary">Posted by: {user_form.name}</h1>
        <img src={link}></img>
        <p className="h3 mt-2">{forum_form.body}</p>
        <Button className="btn btn-lg btn-light text-danger" onClick={updateVotes}>{forum_score} 💗</Button>
        <Form  onSubmit={onSubmit} className="my-3">
          <Form.Row>
            <Col>
              <img src={photo_path(session.photo_hash)} width="50px" height="50px"></img>
            </Col>
            <Col xs={9}>
              <Form.Control type="text" onChange={(ev) => setCom(ev.target.value)}
                value={com} />
            </Col>
            <Col>
              <Button onClick={(ev) => onSubmit(ev)} className="btn btn-info text-light font-weight-bold">Submit</Button>
            </Col>
          </Form.Row>
        </Form>
        <ListingComments/>
        </div>
      )
    }
    else {
      return(
        <div>
        <AddButtons/>
        <h1 className="display-3">{forum_form.title}</h1>
        <h1 className="h4 text-secondary">Posted by: {user_form.name}</h1>
        <img src={link}></img>
        <p className="h3 mt-2">{forum_form.body}</p>
        <h1>{forum_score} 💗</h1>
        <ListingComments/>
        </div>
      )
    }
  }

function state2props({session, forum_form, user_form, forum_score, forumcomments}) {
  return {session, forum_form, user_form, forum_score, forumcomments};
}

export default connect(state2props)(ForumView);
