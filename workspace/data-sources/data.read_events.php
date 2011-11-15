<?php

	require_once(TOOLKIT . '/class.datasource.php');

	Class datasourceread_events extends Datasource{

		public $dsParamROOTELEMENT = 'read-events';
		public $dsParamORDER = 'desc';
		public $dsParamPAGINATERESULTS = 'yes';
		public $dsParamLIMIT = '20';
		public $dsParamSTARTPAGE = '1';
		public $dsParamREDIRECTONEMPTY = 'no';
		public $dsParamSORT = 'system:id';
		public $dsParamASSOCIATEDENTRYCOUNTS = 'no';

		

		public $dsParamINCLUDEDELEMENTS = array(
				'name: formatted',
				'url: formatted',
				'description: formatted',
				'start-date',
				'end-date',
				'map-location',
				'street-address: formatted',
				'suburb: formatted',
				'region: formatted',
				'postcode: formatted',
				'phone: formatted',
				'image'
		);


		public function __construct(&$parent, $env=NULL, $process_params=true){
			parent::__construct($parent, $env, $process_params);
			$this->_dependencies = array();
		}

		public function about(){
			return array(
				'name' => 'Read Events',
				'author' => array(
					'name' => 'Nick Ryall',
					'website' => 'http://nick.sites.randb.com.au/utilities',
					'email' => 'nick@randb.com.au'),
				'version' => 'Symphony 2.2.5',
				'release-date' => '2011-11-15T06:46:46+00:00'
			);
		}

		public function getSource(){
			return '2';
		}

		public function allowEditorToParse(){
			return true;
		}

		public function grab(&$param_pool=NULL){
			$result = new XMLElement($this->dsParamROOTELEMENT);

			try{
				include(TOOLKIT . '/data-sources/datasource.section.php');
			}
			catch(FrontendPageNotFoundException $e){
				// Work around. This ensures the 404 page is displayed and
				// is not picked up by the default catch() statement below
				FrontendPageNotFoundExceptionHandler::render($e);
			}
			catch(Exception $e){
				$result->appendChild(new XMLElement('error', $e->getMessage()));
				return $result;
			}

			if($this->_force_empty_result) $result = $this->emptyXMLSet();

			

			return $result;
		}

	}
