package com.gs.games.darts;

import org.json.JSONException;
import org.json.JSONObject;

public class DartSkin extends Object {
	public String skinid;
	public String flightid;
	
	public JSONObject getJSONObject() {
		JSONObject jso = new JSONObject();
		try {
			jso.put("skinid", skinid);
			jso.put("flightid", flightid);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return jso;
	}
}
