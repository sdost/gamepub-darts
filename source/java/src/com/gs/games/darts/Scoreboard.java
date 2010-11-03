package com.gs.games.darts;

import org.json.JSONException;
import org.json.JSONObject;


public abstract class Scoreboard {
	
	abstract void registerPlayer(int pid);
	
	abstract boolean checkForWin(int player);
	
	abstract boolean submitThrow(int player, int points, int multiplier, int turn, int round);
	
	abstract void getJSONObject(JSONObject jso) throws JSONException;
}
