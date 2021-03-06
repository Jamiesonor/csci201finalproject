package csci201finalproject;

import java.util.ArrayList;

public class Constraint {
	private String startTime;
	private String endTime;
	private String name;
	private ArrayList<Integer> daysInt;

	public Constraint(String startTime, String endTime, String name, String[] days) {
		this.name = name;
		this.startTime = startTime;
		this.endTime = endTime;
		this.daysInt = new ArrayList<Integer>();
		// init our daysInt arraylist
		for (int i = 0; i < days.length; i++) {
			if (days[i].equals("M")) daysInt.add(1);
			if (days[i].equals("T")) daysInt.add(2);
			if (days[i].equals("W")) daysInt.add(3);
			if (days[i].equals("Th")) daysInt.add(4);
			if (days[i].equals("F")) daysInt.add(5);
		}
	}

	public Constraint(String startTime, String endTime, String name, ArrayList<Integer> days) {
		this.name = name;
		this.startTime = startTime;
		this.endTime = endTime;
		this.daysInt = new ArrayList<Integer>();
		// init our daysInt arraylist
		this.daysInt = days;
	}

	public String getStartTime() {
		return this.startTime;
	}

	public String getEndTime() {
		return this.endTime;
	}

	public String getName() {
		return this.name;
	}

	public ArrayList<Integer> getDays() {
		return this.daysInt;
	}

	@Override
	public String toString() {
		return "Constraint{" +
				"startTime='" + startTime + '\'' +
				", endTime='" + endTime + '\'' +
				", name='" + name + '\'' +
				", daysInt=" + daysInt +
				'}';
	}
}