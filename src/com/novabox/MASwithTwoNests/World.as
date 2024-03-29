﻿package com.novabox.MASwithTwoNests 
{
	import adobe.utils.ProductManager;
	import com.GangnamTeam.GangnamType;
	import com.novabox.DummyTeam.DummyType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	/**
	 * Cognitive Multi-Agent System Example
	 * Part 2 : Two distinct termite nests
	 * (Termites collecting wood)
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class World  extends Sprite
	{
		public static const WORLD_WIDTH:Number = 650;
		public static const WORLD_HEIGHT:Number = 600;
		
		public static const BOT_RADIUS:Number = 2;
		public static const BOT_PERCEPTION_RADIUS:Number = 30;
		public static var BOT_COUNT:Number = 80;
		public static const BOT_INIT_POSITION:Point = new Point(WORLD_WIDTH / 2, WORLD_HEIGHT / 2);
		public static const BOT_SPEED:Number = 100;
		public static const BOT_DIRECTION_CHANGE_DELAY:Number = 500;
		
		public static const RESOURCE_LIFE_RADIUS_COEFF:Number = 10;
		public static const RESOURCE_START_LIFE:Number = 3;
		public static const RESOURCE_UPDATE_VALUE:Number = 0.1;
		public static const RESORUCE_RESPAWN_DELAY:Number = 500;
		public static const RESOURCE_COUNT:Number = 15;
		
		
		//WORLD PARAMETERS
		public static var HOME_RADIUS:Number						= 10;
		public static var HOME_GETTING_BIGGER:Boolean				= false;
		public static var RESOURCE_RANDOM_START_LIFE:Boolean		= true;
		public static var BOT_WITH_RESOURCE_SPEED_COEFF:Number	= 1;
		public static var BOT_START_FROM_HOME:Boolean				= false;
		
		public static var RESOURCE_MIN_SPEED:Number					= 5;
		public static var RESOURCE_MAX_SPEED:Number					= 20;
		
		public static const DUMMY_TEAM1:BotTeam = new BotTeam(	"Dummy 1",
																0xAA0000,
																new Array(DummyType.DummyBotType));
																

		public static const DUMMY_TEAM2:BotTeam = new BotTeam(	"Dummy 2",
																0x00FF00,
																new Array(DummyType.DummyBotType));
																
		
		public static const GANGNAM_TEAM:BotTeam = new BotTeam(	"Gangnam",
																0x00FFFF,
																new Array(GangnamType.GangnamBotType));
																
		
		
		public static const ALL_TEAMS:Array = new Array(DUMMY_TEAM1, GANGNAM_TEAM);
																
		private var agents:Array;

		private var size:Point;
		
		public static var teams:Array;
		
		public function World()
		{
			size = null;
		}
		
		public function  Initialize() : void
		{
			size = new Point();
			
			size.x = WORLD_WIDTH;
			size.y = WORLD_HEIGHT;
			
			InitSprite();
			
			
			agents = new Array();
			
			for (var i:int = 0; i < RESOURCE_COUNT; i++)
			{
				var resource:Resource = new Resource();
				
				resource.Initialize(RESOURCE_START_LIFE);
				
				var position:Point = new Point(Math.random() * WORLD_WIDTH, Math.random() * WORLD_HEIGHT);
				
				resource.SetTargetPoint(position);
				
				AddAgent(resource);
				
			}
			
			for each(var team:BotTeam in teams)
			{
				team.Initialize(BOT_COUNT);
			}
		}
		
		protected function InitSprite() : void
		{
			this.graphics.beginFill(0X555555, 1);
				this.graphics.drawRect(0, 0, size.x, size.y);
			this.graphics.endFill();	
		}
		
		public function Update(): void
		{
			for (var i:int = 0; i < agents.length; i++)
			{
				var agent:Agent = agents[i];
				agent.Update();
				
				if (!IsOut(agent.GetTargetPoint()))
				{
					Move(agent, agent.GetTargetPoint());
				}
				
			}
			CleanDeadAgents();
			
			CheckCollisions();
		}
		
		public function CleanDeadAgents() : void 
		{
			var deadAgentIndex:int = -1;
			var foundDeadAgent:Boolean = true;
			
			while (foundDeadAgent)
			{
				if (deadAgentIndex != -1)
				{
					var deadAgent:Agent = agents[deadAgentIndex];
					removeChild(deadAgent);
					agents.splice(deadAgentIndex, 1);
					deadAgentIndex = -1;
				}
				foundDeadAgent = false;
				
				for (var i:int = 0; i < agents.length; i++)
				{
					var agent:Agent = agents[i];
					
					if (agent.IsDead())
					{
						foundDeadAgent = true;
						deadAgentIndex = i;
					}
				}
				
			}
		}
		
		public function IsOut(_point:Point) : Boolean
		{
			if ((_point.x <= 0) || (_point.x >= size.x))
			{
					return true;
			}
			if ((_point.y <= 0) || (_point.y >= size.y))
			{
					return true;				
			}
			
			return false;
		}
		
		public function Move(_agent:Agent, _point:Point) : void
		{
			_agent.x = _point.x;
			_agent.y = _point.y;
		}
		
		public function CheckCollisions() : void
		{
			for (var i:int = 0; i < agents.length; i++)
			{
				var agent:Agent = agents[i];
				
				for (var j:int = i; j < agents.length; j++)
				{
					var collidedAgent:Agent = agents[j];
					if (agent.hitTestObject(collidedAgent))
					{
						agent.dispatchEvent(new AgentCollideEvent(collidedAgent));
						collidedAgent.dispatchEvent(new AgentCollideEvent(agent));
					}
				}
			}
		}
		
		public function AddAgent(_agent:Agent) : void
		{
			addChild(_agent);
			agents.push(_agent);
		}
	}
}