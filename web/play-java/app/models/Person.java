package models;

import play.db.ebean.Model;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Person extends Model
{
	@Id
	public String id;
	public String name;
	public String age;
	public String gender;
	public String email;
}
