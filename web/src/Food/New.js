import { Row, Col, Form, Button} from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useHistory, NavLink  } from 'react-router-dom';
import pick from 'lodash/pick';
import store from '../store';
import { create_food , fetch_foods, fetch_users } from '../api';

function FoodNew({session}) {
  let history = useHistory();
  const [food, setFood] = useState({
    user_id: session.user_id, body: "", brand: "", price:0,
    type: ""
  })

  function onSubmit(ev) {
    ev.preventDefault();
    let data = pick(food, ['user_id', 'body', 'type', 'brand',
    "photo", "price"]);
    create_food(data).then((data) => {
        if(data.error) {
          let action={
            type:"error/set",
            data: data.error
          }
          store.dispatch(action)
        }
        else {
          fetch_foods()
          fetch_users()
          history.push("/food/list")
        }
    });
  }
  function update(field, ev) {
    let u1 = Object.assign({}, food);
    u1[field] = ev.target.value;
    setFood(u1);
  }

  function updatePhoto(ev) {
    let p1 = Object.assign({}, food);
    p1["photo"] = ev.target.files[0];
    setFood(p1);
    console.log(food)
  }

  return(
      <Form onSubmit={onSubmit}>
        <Form.Group>
          <h1 className="mt-5">Create Food Recommendation</h1>
          <Form.Label>Product Brand</Form.Label>
          <Form.Control type="text"
                        onChange={
                          (ev) => update("brand", ev)}
            value={food.brand} />
        </Form.Group>
        <Form.Group>
              <Form.Label>Product Image</Form.Label>
              <Form.Control type="file" onChange={updatePhoto} />
        </Form.Group>
        <Form.Group>
          <Form.Label>Product Description</Form.Label>
          <Form.Control type="textarea"
                        onChange={
                          (ev) => update("body", ev)}
            value={food.body} />
        </Form.Group>
        <Form.Group controlId="formBasicRange">
          <Form.Label>Product Price: {food.price}$ per lbs</Form.Label>
          <Form.Control type="range" onChange={(ev) => update("price", ev)} value={food.price}/>
        </Form.Group>
        <Form.Group controlId="exampleForm.ControlSelect1">
          <Form.Label>Product Type</Form.Label>
          <Form.Control as="select" onChange={(ev) => update("type", ev)} value={food.type}>
            <option></option>
            <option>Kitten Food</option>
            <option>Adult Food</option>
            <option>Wet Food</option>
            <option>Dried Food</option>
            <option>Semi-moist Food</option>
            <option>Other</option>
          </Form.Control>
        </Form.Group>
        <Button variant="primary" type="submit" className="h3 font-weight-bold mr-3">
          Save
        </Button>
      </Form>
    );
}

function state2props({session}) {
  return {session};
}

export default connect(state2props)(FoodNew);
