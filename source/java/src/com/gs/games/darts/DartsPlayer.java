package com.gs.games.darts;

import org.json.JSONException;
import org.json.JSONObject;

public class DartsPlayer {
	private int _playerInd;
	private DartSkin _dartSkin;
	private DartsStats _stats;
	
	public double bullOffResult;
	
	public DartsPlayer(int ind) 
	{
		_playerInd = ind;
		
		_dartSkin = new DartSkin();
		_stats = new DartsStats();
		
		bullOffResult = -1.0;
	}
	
	public void setSkinId(String s)
	{
		_dartSkin.skinid = s;
	}
	
	public void setFlightId(String s)
	{
		_dartSkin.flightid = s;
	}
	
	public void addThrow()
	{
		_stats.throwsCount++;
	}
	
	public void addScoringThrow()
	{
		_stats.scoringThrows++;
	}
	
	public void resetScoringThrows()
	{
		_stats.scoringThrows = 0;
	}
	
	public void addDoubleScore()
	{
		_stats.doubles++;
	}
	
	public void addTripleScore()
	{
		_stats.triples++;
	}
	
	public int getPlayerInd()
	{
		return _playerInd;
	}
	
	public void addSkinJSON(JSONObject jso)
	{
		try {
			jso.put("playerSkin" + _playerInd, _dartSkin.getJSONObject());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void addStatsJSON(JSONObject jso)
	{
		try {
			jso.put("playerStats" + _playerInd, _stats.getJSONObject());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
