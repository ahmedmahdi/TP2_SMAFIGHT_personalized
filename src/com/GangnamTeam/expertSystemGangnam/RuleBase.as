﻿package com.GangnamTeam.expertSystemGangnam 
{
	/**
	 * Expert System 
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class RuleBase
	{
		private var rules:Array;
		
		public function RuleBase() 
		{
			rules = new Array();
			
			//Recherche de ressource
			AddRule(new Rule(FactBase.vaExplorer, new Array(FactBase.nePortePasDeRessource, FactBase.neConnaitPasDeRessource)));
			AddRule(new Rule(FactBase.vaChercherRessourcePlusPres, new Array(FactBase.nePortePasDeRessource, FactBase.connaitDesRessources)));
			
			//Détection
			AddRule(new Rule(FactBase.recupererInfosRessource, new Array(FactBase.detecteRessource)));
			AddRule(new Rule(FactBase.recupererInfosRessource, new Array(FactBase.detecteBaseEnnemie)));
			AddRule(new Rule(FactBase.recupererInfosRessource, new Array(FactBase.detecteBaseAlliee)));
			
			AddRule(new Rule(FactBase.communiquerInfosRessource, new Array(FactBase.detecteBotAllie)));
			
			//Collision
			AddRule(new Rule(FactBase.prendRessource, new Array(FactBase.collisionneRessource, FactBase.nePortePasDeRessource)));
			AddRule(new Rule(FactBase.prendRessource, new Array(FactBase.collisionneBaseEnnemie, FactBase.nePortePasDeRessource)));
			AddRule(new Rule(FactBase.prendRessource, new Array(FactBase.collisionneBotEnnemi, FactBase.nePortePasDeRessource)));
			AddRule(new Rule(FactBase.poseRessource, new Array(FactBase.porteRessource, FactBase.collisionneBaseAlliee)));
			
			//Porte une ressource
			AddRule(new Rule(FactBase.vaALaBaseAlliee, new Array(FactBase.porteRessource)));
			
			
		}
		
		public function AddRule(_rule:Rule) : void
		{
			rules.push(_rule);
		}
		
		public function GetRules() : Array
		{
			return rules;
		}
		
	}

}