﻿package com.GangnamTeam.expertSystemGangnam 
{
	import com.novabox.expertSystem.Fact;
	/**
	 * Expert System 
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class FactBase
	{
		
		private var facts:Array;
		
		private var factValues:Array;
		
		public static const porteRessource 			= new Fact("porteRessource");
		public static const nePortePasDeRessource 	= new Fact("nePortePasDeRessource");
		
		public static const detecteRessource 		= new Fact("detecteRessource");
		public static const detecteBotEnnemi 		= new Fact("detecteBotEnnemi");
		public static const detecteBotAllie 		= new Fact("detecteBotAllie");
		public static const detecteBaseEnnemie 		= new Fact("detecteBaseEnnemie");
		public static const detecteBaseAlliee 		= new Fact("detecteBaseAlliee");
		
		public static const collisionneRessource 	= new Fact("collisionneRessource");
		public static const collisionneBotEnnemi 	= new Fact("collisionneBotEnnemi");
		public static const collisionneBotAllie 	= new Fact("collisionneBotAllie");
		public static const collisionneBaseEnnemie 	= new Fact("collisionneBaseEnnemie");
		public static const collisionneBaseAlliee 	= new Fact("collisionneBaseAlliee");
		
		public static const aUnOrdre = new Fact("AUnOrdre");
		public static const naPasDOrdre = new Fact("naPasDOrdre");
		
		public function FactBase() 
		{
			facts = new Array();
			factValues = new Array();
		}
		
		public function AddFact(_fact:Fact) : void
		{
			facts.push(_fact);
			SetFactValue(_fact, false);
		}
		
		public function HasFact(_fact:Fact) : Boolean
		{
			for (var i:int = 0; i < facts.length; i++)
			{
				if (facts[i] == _fact)
				{
					return true;
				}
			}
			return false;
		}
				
		public function SetFactValue(_fact:Fact, _value:Boolean) : void
		{
			if (HasFact(_fact))
			{
				factValues[_fact.GetLabel()] = _value;
			}
		}
		
		public function GetFactValue(_fact:Fact) : Boolean
		{
			if (HasFact(_fact))
			{
				return factValues[_fact.GetLabel()];
			}
			return false;
		}
		
		public function ResetFacts() : void
		{
			for (var i:int = 0; i < facts.length; i++)
			{
				var fact:Fact = (facts[i] as Fact);
				SetFactValue(fact, false);
			}
		}
		
	}

}