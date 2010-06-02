package com.gs.games.darts;

import org.json.JSONException;
import org.json.JSONObject;

public class DartsStats {
	public int throwsCount;
	
	public int scoringThrows;
	
	public int doubles;
	public int triples;
	
	public boolean win;
	
	public JSONObject getJSONObject() {
		JSONObject jso = new JSONObject();
		try {
			jso.put("throws", throwsCount);
			jso.put("scoringThrows", scoringThrows);
			jso.put("doubles", doubles);
			jso.put("triples", triples);
			jso.put("win", win);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return jso;
	}
}
