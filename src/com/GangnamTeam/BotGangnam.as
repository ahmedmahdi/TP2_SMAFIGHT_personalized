package com.GangnamTeam 
{
	import com.GangnamTeam.expertSystemGangnam.ExpertSystem;
	import com.GangnamTeam.expertSystemGangnam.FactBase;
	import com.novabox.MASwithTwoNests.AgentCollideEvent;
	import com.novabox.MASwithTwoNests.AgentType;
	import com.novabox.MASwithTwoNests.Bot;
	import com.novabox.MASwithTwoNests.BotHome;
	import com.novabox.MASwithTwoNests.Resource;
	import com.novabox.MASwithTwoNests.Agent;
	import com.novabox.MASwithTwoNests.TimeManager;
	import com.novabox.MASwithTwoNests.World;
	
	/**
	 * ...
	 * @author Charco
	 */
	public class BotGangnam extends Bot 
	{
		private var systemeExpertGangnam:ExpertSystem;
		
		//public static const poseRessource:int							= 1;
		//public static const prendRessource:int							= 2;
		//public static const vaChercherRessourcePlusPres:int				= 3;
		//public static const vaChercherRessourceAvecLePlusDeCapacite:int	= 4;
		//public static const vaExplorer:int								= 5;
		//public static const vaALaBaseAlliee:int							= 6;
		//public static const vaALaBaseEnnemieLaPlusPres:int				= 7;
		//public static const vaALaBaseEnnemieAvecLePlusDeCapacite:int	= 8;

		
		private var listeRessources:Array;
		
		private var agentActuel:Agent;
	
		protected var updateTime:Number;
		
		public function BotGangnam(_type:AgentType) 
		{
			listeRessources = new Array ();
			systemeExpertGangnam = new ExpertSystem ();
			updateTime = 0;
			super(_type);
		}
		
		override public function Update() : void
		{
			Perception();
			Analyse();
			Action();
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS DE PERCEPTION ######################### */
		/* ################################################################################################ */
		
		
		public function Perception() : void {
			// On reset les faits
			systemeExpertGangnam.ResetFacts();
			
			// appel fonctions qui set les faits
			setFactConnaitRessources ();
		}
		
		private function setFactConnaitRessources () : void
		{
			if (isRessourcesConnuesDisponibles())
				systemeExpertGangnam.SetFactValue(FactBase.connaitDesRessources, true);
			else
				systemeExpertGangnam.SetFactValue(FactBase.neConnaitPasDeRessource, true);
		}
		
		override public function onAgentCollide(_event:AgentCollideEvent) : void
		{
			var agentActuel:Agent = _event.GetAgent();
			
			// Collision 
			if (IsCollided(agentActuel)) {
				setFactCollision(agentActuel);
			}
			// Perception
			else
			{
				setFactPerception(agentActuel);
			}
			//if (!HasResource())
		}
		
		private function setFactCollision(_collidedAgent:Agent):void 
		{
			if (_collidedAgent.GetType () == AgentType.AGENT_RESOURCE)
				systemeExpertGangnam.SetFactValue(FactBase.collisionneRessource, true);
			if (_collidedAgent.GetType () == AgentType.AGENT_BOT_HOME)
			{
				if (isBaseAlliee(_collidedAgent as BotHome))
					systemeExpertGangnam.SetFactValue(FactBase.collisionneBaseAlliee, true);
				else if (!isBaseAlliee(_collidedAgent as BotHome))
					systemeExpertGangnam.SetFactValue(FactBase.collisionneBaseEnnemie, true);
			}
			if (_collidedAgent.GetType () == AgentType.AGENT_BOT)
			{
				if (isBotAllie(_collidedAgent as Bot))
					systemeExpertGangnam.SetFactValue(FactBase.collisionneBotAllie, true);
				else if (!isBotAllie(_collidedAgent as Bot))
					systemeExpertGangnam.SetFactValue(FactBase.collisionneBotEnnemi, true);
			}
		}
		
		private function setFactPerception(_collidedAgent:Agent):void 
		{
			if (_collidedAgent.GetType () == AgentType.AGENT_RESOURCE)
				systemeExpertGangnam.SetFactValue(FactBase.detecteRessource, true);
			if (_collidedAgent.GetType () == AgentType.AGENT_BOT_HOME)
			{
				if (isBaseAlliee(_collidedAgent as BotHome))
					systemeExpertGangnam.SetFactValue(FactBase.detecteBaseAlliee, true);
				else if (!isBaseAlliee(_collidedAgent as BotHome))
					systemeExpertGangnam.SetFactValue(FactBase.detecteBaseEnnemie, true);
			}
			if (_collidedAgent.GetType () == AgentType.AGENT_BOT)
			{
				if (isBotAllie(_collidedAgent as Bot))
					systemeExpertGangnam.SetFactValue(FactBase.detecteBotAllie, true);
				else if (!isBotAllie(_collidedAgent as Bot))
					systemeExpertGangnam.SetFactValue(FactBase.detecteBotEnnemi, true);
			}
		}
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS D'ANALYSE ############################# */
		/* ################################################################################################ */		
		
		
		public function Analyse() : void {

			systemeExpertGangnam.InferForward();
			var inferedFacts:Array = systemeExpertGangnam.GetInferedFacts();
			//trace("Infered Facts:");

			systemeExpertGangnam.InferBackward();
			var factsToAsk:Array = systemeExpertGangnam.GetFactsToAsk();
			//trace("Facts to ask :");
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS D'ACTION ############################## */
		/* ################################################################################################ */		
		
		
		public function Action() : void {
			// Recupere le ou les faits finaux (normalement un seul)
			var tabFaitsFinaux:Array = systemeExpertGangnam.GetInferedFacts();
			var indice:int;
			
			if (tabFaitsFinaux.length == 1)
				indice = 0;
			else
				// Comme la table de regle va de check/Fold à Raise, on prend la dernier indice, ce qui permet de choisir de suivre meme si une regle check/fold est vraie 
				//(normalement cette confrontation de regles est impossible, simple sécurité) 
				indice = tabFaitsFinaux.length - 1;

				
			trace(tabFaitsFinaux.length);
			if (tabFaitsFinaux [indice] == FactBase.vaExplorer) 	
				Explorer();
			else if (tabFaitsFinaux [indice] == FactBase.communiquerInfosRessource)
				communiqueInformations(agentActuel);
			else if (tabFaitsFinaux [indice] == FactBase.recupererInfosRessource)
				recupereInformations(agentActuel);
			else if (tabFaitsFinaux [indice] == FactBase.poseRessource)
				PoseRessource(agentActuel);
			else if (tabFaitsFinaux [indice] == FactBase.prendRessource)
				PrendRessource(agentActuel);
			else if (tabFaitsFinaux [indice] == FactBase.vaChercherRessourcePlusPres)
				PrendRessource(agentActuel);
			else if (tabFaitsFinaux [indice] == FactBase.vaChercherRessourceAvecLePlusDeCapacite)
				PrendRessource(agentActuel);
			else if (tabFaitsFinaux [indice] == FactBase.vaALaBaseAlliee)
				PrendRessource(agentActuel);
			else if (tabFaitsFinaux [indice] == FactBase.vaALaBaseEnnemieLaPlusPres)
				PrendRessource(agentActuel);
			else if (tabFaitsFinaux [indice] == FactBase.vaALaBaseEnnemieAvecLePlusDeCapacite)
				PrendRessource(agentActuel);
				
			//else if ()
			
				//Call (_pokerTable.GetValueToCall());
			//else if (tabFaitsFinaux [indice] == FactBase.EVENT_RELANCER) 	
				// On effectue une relance aléatoire comprise entre 1 et 4 fois la big blind
				//Raise(Math.floor((Math.random() * 3) + 1) * _pokerTable.GetBigBlind(), _pokerTable.GetValueToCall());
			//else if (this.CanCheck(_pokerTable))
				//Check();
			//else
				//Fold ();
		}
		
		
		public function communiqueInformations (_agent:Agent) : void
		{
			//TODO
		}
		
		public function recupereInformations (_agent:Agent) : void
		{
			//TODO
		}
		
		public function PrendRessource (_collidedAgent:Agent) : void
		{
			if (_collidedAgent.GetType () == AgentType.AGENT_RESOURCE)
			{
				(_collidedAgent as Resource).DecreaseLife();
				SetResource(true);
			}
			else if (_collidedAgent.GetType() == AgentType.AGENT_BOT_HOME)
			{
				(_collidedAgent as BotHome).TakeResource();
				SetResource(true);
			}
		}
		
		public function PoseRessource (_collidedAgent:Agent) : void
		{
			if (_collidedAgent.GetType () == AgentType.AGENT_RESOURCE)
			{
				(_collidedAgent as Resource).IncreaseLife();
				SetResource(false);
			}
			else if (_collidedAgent.GetType() == AgentType.AGENT_BOT_HOME)
			{
				(_collidedAgent as BotHome).AddResource();
				SetResource(false);
			}
		}
		
		public function Explorer () : void
		{
			var elapsedTime:Number = TimeManager.timeManager.GetFrameDeltaTime();
			
			updateTime += elapsedTime;
				
			if (updateTime >=  directionChangeDelay)
			{
				ChangeDirection();
				updateTime = 0;
			}
			
			
			 targetPoint.x = x + direction.x * speed * elapsedTime / 1000 ;
			 targetPoint.y = y + direction.y * speed * elapsedTime / 1000;
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS ANNEXES ############################### */
		/* ################################################################################################ */
		
		
		public function isRessourcesConnuesDisponibles () : Boolean
		{
			var nbRessources:int = 0;
			for each (var ressource:Ressource in listeRessources)
			{
				nbRessources = nbRessources + ressource.getCapacite();
			}
			return nbRessources > 0;
			
		}
		
		public function isBaseAlliee (_botHome:BotHome) : Boolean
		{
			return (_botHome.GetTeamId() == World.GANGNAM_TEAM.GetId());
		}
		
		public function isBotAllie (_bot:Bot) : Boolean
		{
			return (_bot.GetTeamId() == World.GANGNAM_TEAM.GetId());
		}
		
		
		public function getRessourceByPointeur (_maRessource:Ressource) : Ressource
		{
			for each (var ressource:Ressource in listeRessources)
			{
				if (_maRessource.getPointeurRessource() == ressource.getPointeurRessource())
					return ressource;
			}
			return null;
		}
		
		
	}

}