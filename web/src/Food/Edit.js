import { Row, Col, Form, Button} from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useHistory, NavLink, useLocation  } from 'react-router-dom';
import pick from 'lodash/pick';
import store from '../store';
import { fetch_food, update_food , fetch_foods, fetch_users, fetch_user} from '../api';

//referenced from lecture code SPA Structure from Nat Tuck CS4550 Northeastern University 
function FoodNew({session, food_form, user_form}) {
  let location = useLocation()
  let history = useHistory()
  let food_id = location.pathname.split("/food/edit/")[1]

  if(typeof(food_form.id) == "undefined" || food_form.id != food_id) {
    fetch_foods()
    fetch_food(food_id)
  }

  if(typeof(user_form.id) == "undefined" || user_form.id != food_form.user_id){
    fetch_foods()
    fetch_user(food_form.user_id)
  }

  const [food, setFood] = useState({
    user_id: session.user_id, body: food_form.body, brand: food_form.brand, price: food_form.price,
    type: food_form.type, id: food_form.id
  })

  function onSubmit(ev) {
    ev.preventDefault();
    let data = pick(food, ['id', 'user_id', 'body', 'type', 'brand',
    "photo", "price"]);
    update_food(data).then((data) => {
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
          <h1 className="mt-5">Edit Food Recommendation</h1>
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

function state2props({session, food_form, user_form}) {
  return {session, food_form, user_form};
}

export default connect(state2props)(FoodNew);
