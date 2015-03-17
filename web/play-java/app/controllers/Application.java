package controllers;

import models.Person;
import play.*;
import play.data.Form;
import play.db.ebean.Model;
import play.mvc.*;

import views.html.*;

import java.util.List;

import static play.libs.Json.toJson;

public class Application extends Controller 
{
	//private static List<Person> persons;
    	public static Result index() 
    	{
        	return ok(index.render("Hello World!"));
    	}
	public static Result addPerson()
	{
		Person person = Form.form(Person.class).bindFromRequest().get();
		person.save();	
		return redirect(routes.Application.index());
	}
	public static Result getPersons()
	{
		List<Person> persons = new Model.Finder(String.class, Person.class).all();
		return ok(toJson(persons));
	}
}
