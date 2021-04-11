import { CardColumns, Card, Form } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Link, useHistory, NavLink, useLocation } from 'react-router-dom';
import { fetch_foods} from '../api';
import Carousel from 'react-bootstrap/Carousel';

function FoodList({session, foods}) {
  function photo_path(hash) {
    return "http://localhost:4000/photos/" + hash;
  }
  function ListingFoodArticles() {
    let rows = foods.map((food) => {
      const link = "view/" + food.id
      const image_link = photo_path(food.photo_hash)
      return (
        <Card>
          <Card.Img variant="top" src={image_link} />
          <Card.Body>
            <Card.Title>{food.brand}</Card.Title>
            <Card.Text>{food.body}</Card.Text>
            <Link to={link}>Check For More Info</Link>
          </Card.Body>
        </Card>
      )})
      return <CardColumns>{rows}</CardColumns>
    }

    function AddNewWellnessButton() {
      if (session) {
        return(
          <Link to="/food/new" className="btn btn-lg font-weight-bold btn-info my-3">
            New Food Recommendation</Link>
        )
      }
      else {
        return(
          <br></br>
        )
      }
    }

    return(
      <div>
        <p className="display-1">Food Choices</p>
        <AddNewWellnessButton />
        <ListingFoodArticles/>
      </div>);
    }

function state2props({session, foods}) {
  return {session, foods};
}

export default connect(state2props)(FoodList);
