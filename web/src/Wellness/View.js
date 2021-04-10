import { Button, Nav, NavRow, Row, Col, Card, Form } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Link, useHistory, useLocation, NavLink } from 'react-router-dom';
import { useState } from 'react';
import { delete_comment, create_comment, fetch_comments, delete_wellness, fetch_score, fetch_wellness,
  fetch_single_wellness, fetch_user, update_wellness_vote } from '../api';
import store from '../store';

function WellnessView({session, wellness_form, user_form, score, comments}) {
  let location = useLocation()
  let history = useHistory()
  let wellness_id = location.pathname.split("/wellness/view/")[1]

  if(typeof(wellness_form.id) == "undefined" || wellness_form.id != wellness_id) {
    fetch_single_wellness(wellness_id)
    fetch_score(wellness_id)
    fetch_comments(wellness_id)
  }

  if(typeof(user_form.id) == "undefined" || user_form.id != wellness_form.user_id){
    fetch_user(wellness_form.user_id)
  }

  function photo_path(hash) {
    return "http://localhost:4000/photos/" + hash;
  }

  function deleteWellness(){
    delete_wellness(wellness_id)
    history.push("/wellness/list")
  }

  function AddButtons() {
    if(session && session.user_id == user_form.id) {
      let link = "/wellness/edit/" + wellness_form.id
      return(
        <div>
        <Link to={link} className="btn mt-2 btn-lg btn-info text-light mr-2 font-weight-bold">Edit</Link>
        <Button onClick={deleteWellness} className="btn mt-2 btn-lg btn-danger text-light mr-2 font-weight-bold">Delete</Button>
        <Link to="/wellness/list" className="btn btn-lg mt-2 btn-info text-light  font-weight-bold">Back</Link>
        </div>
      )
    }
    else {
      return(
        <Link to="/wellness/list" className="btn btn-lg mt-2 btn-danger text-light  font-weight-bold">Back</Link>
      )
    }
  }

  let link = photo_path(wellness_form.photo_hash)

  function updateVotes() {
    if(wellness_form.votes.includes(session.user_id)) {
      update_wellness_vote(wellness_form, session.user_id, "decrease")
      fetch_wellness()
      fetch_single_wellness(wellness_form.id)
      fetch_score(wellness_form.id)
    }
    else {
      update_wellness_vote(wellness_form, session.user_id, "increase")
      fetch_wellness()
      fetch_single_wellness(wellness_form.id)
      fetch_score(wellness_form.id)
    }
  }

  function photo_path(hash) {
    return "http://localhost:4000/photos/" + hash;
  }

  function EditCommentButton({comment}) {
    function deleteComment() {
      delete_comment(comment.id, wellness_id)
    }

    if (session && comment.user_id == session.user_id) {
      return <Button onClick={deleteComment} className="btn mt-2 btn-danger text-light font-weight-bold">Delete</Button>
    }
    else {
      return <div></div>
    }
  }

  function ListingComments() {
    let rows = comments.map((comment) => {
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
      create_comment(com, session.user_id, wellness_id).then((data) => {
          if(data.error) {
            let action={
              type:"error/set",
              data: data.error
            }
            store.dispatch(action)
          }
          else {
            setCom("")
            fetch_comments(wellness_id)
            fetch_wellness()
          }
      });
    }

    if (session) {
      return(
        <div>
        <AddButtons/>
        <h1 className="display-3">{wellness_form.title}</h1>
        <h1 className="h4 text-secondary">Posted by: {user_form.name}</h1>
        <img src={link}></img>
        <p className="h3 mt-2">{wellness_form.body}</p>
        <Button className="btn btn-lg btn-light text-danger" onClick={updateVotes}>{score} 💗</Button>
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
        <h1 className="display-3">{wellness_form.title}</h1>
        <h1 className="h4 text-secondary">Posted by: {user_form.name}</h1>
        <img src={link}></img>
        <p className="h3 mt-2">{wellness_form.body}</p>
        <h1>{score} 💗</h1>
        <ListingComments/>
        </div>
      )
    }
  }

function state2props({session, wellness_form, user_form, score, comments}) {
  return {session, wellness_form, user_form, score, comments};
}

export default connect(state2props)(WellnessView);
