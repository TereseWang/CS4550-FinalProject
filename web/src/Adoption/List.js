import { Card, CardColumns, Button, Form } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Link} from 'react-router-dom';
import { useState } from 'react';
import pick from 'lodash/pick';
import {fetch_adoption} from '../api';
import store from '../store';

function FoodList({adoption, cat_breed }) {
  const [engine, setEngine] = useState({
    breed: "Abyssinian", page: 1
  });

  function update(field, ev) {
    let u1 = Object.assign({}, engine);
    u1[field] = ev.target.value;
    setEngine(u1);
  }

  function updatePage(ev, action) {
    let u1 = Object.assign({}, engine);
    if (action == "increase") {
      u1["page"] = engine.page + 1;
      setEngine(u1);
      fetch_adoption(engine.page)
    }
    else if (engine.page > 1) {
      u1["page"] = engine.page - 1;
      setEngine(u1);
      fetch_adoption(engine.page)
    }
  }

  function ListingAdoptions() {
    var link;
    var neutered;
    var location;
    let rows = adoption.map((cat) => {
      if (cat.photos.length > 0) {
        link = cat.photos[0].medium
      }
      if(cat.attributes.spayed_neutered) {
        neutered = "Yes"
      }
      else {
        neutered = "No"
      }
      location = cat.contact.address.city
      return (
        <Card>
          <Card.Img variant="top" src={link} />
          <Card.Body>
            <Card.Title>Cat Name: {cat.name}</Card.Title>
            <Card.Text>Gender: {cat.gender}</Card.Text>
            <Card.Text>Age: {cat.age}</Card.Text>
            <Card.Text>Breed: {cat.breeds.primary}</Card.Text>
            <Card.Text>Size: {cat.size}</Card.Text>
            <Card.Text>spayed_neutered: {neutered}</Card.Text>
            <Card.Text>Location: {location}</Card.Text>
            <Card.Text>{cat.description}</Card.Text>
            <a href={cat.url} target="_blank">Adoption Link</a>
          </Card.Body>
        </Card>
      )})
    return <CardColumns>{rows}</CardColumns>
  }

  function ListingBreed() {
    let rows = cat_breed.map((breed) => {
      return <option>{breed.name}</option>
    })
    return (<Form.Control as="select" onChange={(ev) => update("breed", ev)} value={engine.breed}>{rows}</Form.Control>);
  }

  return(
    <div>
      <p className="display-1">Adoption Center</p>
      <div class="row">
        <Button className="btn btn-lg btn-light text-dark" onClick={(ev) => updatePage(ev, "decrease")} value={engine.index}>⬅</Button>
        <h1>{engine.page}</h1>
        <Button className="btn btn-lg btn-light text-dark" onClick={(ev) => updatePage(ev, "increase")} value={engine.index}>&#10145;</Button>
      </div>
      <ListingAdoptions/>
    </div>
  )
}

function state2props({adoption, cat_breed}) {
  return {adoption, cat_breed };
}

export default connect(state2props)(FoodList);
