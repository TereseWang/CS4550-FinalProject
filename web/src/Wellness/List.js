import { Button, Nav, NavRow, Row, Col, Card, Form } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { Link, useHistory, NavLink, useLocation } from 'react-router-dom';
import { fetch_user, fetch_single_wellness, fetch_wellness, search_wellness } from '../api';
import Carousel from 'react-bootstrap/Carousel';

function WellnessList({wellness, session}) {
  let history = useHistory()
  let location = useLocation();

  function photo_path(hash) {
    return "http://kittenlover-backend.teresewang.com/photos/" + hash;
  }

  function AddNewWellnessButton() {
    if (session) {
      return(
        <Redirect to="/wellness/new" className="btn btn-lg font-weight-bold btn-info ml-3">
          New Wellness Post
        </Redirect>
      )
    }
    else {
      return(
        <br></br>
      )
    }
  }

  function ListingArticles({session, current_wellness}) {
    let rows = wellness.map((health) => {
      let body = health.body.substring(0, 280) + " ..."
      const link = "/wellness/view/"+ health.id
      let score = health.votes.length
      return (
        <Card fluid className="my-4">
          <Card.Header>{score} 💗</Card.Header>
          <Card.Body>
            <h1 className="">{health.title}</h1>
            <p>{body}</p>
            <Link to={link}  className="text-danger">Read More</Link>
          </Card.Body>
        </Card>
    )});

    return(
      <div className="ml-3">
        {rows}
      </div>
    )
  }

  function Redirect({to, children}) {
    return (
      <Nav.Item>
        <NavLink to={to} exact
          className="btn btn-lg font-weight-bold text-light btn-info"
          activeClassName="active">
          {children}
        </NavLink>
      </Nav.Item>
    );
  }

  function ImageGallery() {
    let query = wellness
    if (wellness.length >= 5) {
      query = Object.entries(wellness).slice(0,5).map(entry => entry[1]);
    }
    let rows = query.map((health) => {
      let body = health.body.substring(0, 280) + " ..."
      let link = "/wellness/view/" + health.id;
      return (
        <Carousel.Item>
          <img src={photo_path(health.photo_hash)} width="100%" height="600px"></img>
          <Carousel.Caption>
            <Link to={link}  className="text-info h3">Direct To Article: {health.title}</Link>
          </Carousel.Caption>
        </Carousel.Item>
    )});
    return(
      <Carousel className="my-3">
        {rows}
      </Carousel>
    )
  }

  const UpdatingArticles = connect(
      ({session, current_wellness}) => ({session, current_wellness}))(ListingArticles);


  const [search, setSearch] = useState("");

  function update(ev) {
    setSearch(ev.target.value);
  }

  function searchQuery(ev){
    ev.preventDefault();
    search_wellness(search);
  }

  return (
    <div>
      <p className="display-1">Wellness</p>
      <p className="h4">Regular wellness care is of the utmost importance for any pet,
      but trips to the veterinarian often end up on the back burner when
      it comes to our cats. This pro-cats-tination could be due to a general
      dislike of car rides, carriers, handling without their consent,
      or because cats are experts at masking symptoms,
      hiding pain and making us believe that there is nothing wrong.
      Because of this, many felines don’t get the care they need until their
      health problems become serious.
      Preventing illness and disease in our feline companions is easier,
      healthier, and cheaper than attempting to treat a problem once it arises.
      You will find articles below to be helpful, and you can also make
      helpful posts to help others. <br></br><a href='http://www.catcareofvinings.com/blog/wellness-care-for-cats/' target="_blank">Referenced from Cat Care</a></p>
      <ImageGallery />
      <Row>
        <Col>
          <AddNewWellnessButton />
        </Col>
      </Row>
      <Form onSubmit={searchQuery} inline>
        <Form.Group className="mt-3 ml-3">
          <Form.Control type="text" placeholder="Search.." onChange={(ev) => update(ev)} value={search} />
        </Form.Group>
        <Button variant="primary" type="submit" className="h3 font-weight-bold mr-3 ml-1 mt-4">Search</Button>
      </Form>
      <UpdatingArticles />
    </div>
  );
}

function state2props({wellness, session}) {
  return { wellness, session};
}

export default connect(state2props)(WellnessList);
