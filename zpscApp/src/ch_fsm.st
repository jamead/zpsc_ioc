/* Sequencer to control the PSC IOC startup.*/

#define PRINTF seqLog

program ch_fsm ("M0=lab{2}, M1=Chan1")


/* ============================================================
   Options
   ------------------------------------------------------------
   +r : Reentrant (allows multiple instances)
   -c : Do not wait for all assigned PVs to connect at startup
   ============================================================ */
   
option +r;
option -c;


short DAC; 
assign DAC to "{M0}{M1}:DAC_SetPt-SP"; 
monitor DAC; 

short DAC_rdbck; 
assign DAC_rdbck to "{M0}{M1}:DAC-I"; 
monitor DAC_rdbck; 

short Park; 
assign Park to "{M0}{M1}:DigOut_Park-SP";
monitor Park;

/*Will need to be updated for channel to channel unipolar/bipolar operation */
short Polarity; 
assign Polarity to "{M0}Polarity-Mode"; 
monitor Polarity; 

short flt_mask; 
assign flt_mask to "{M0}{M1}:FaultMask:B12-SP"; 
monitor flt_mask; 

short flt_clr; 
assign flt_clr to "{M0}{M1}:FaultClear-SP"; 
monitor flt_clr; 

short ps_on_off; 
assign ps_on_off to "{M0}{M1}:PSOnOff-SP"; 
monitor ps_on_off; 

short ps_on_off_sts; 
assign ps_on_off_sts to "{M0}{M1}:PSOnOff-STS"; 
monitor ps_on_off_sts; 

short ps_on_sts; 
assign ps_on_sts to "{M0}{M1}:DigIn-I.B0"; 
monitor ps_on_sts; 

short on1_cmd; 
assign on1_cmd to "{M0}{M1}:DigOut_ON1-SP"; 

short ch1_en_cmd; 
assign ch1_en_cmd to "{M0}Chan1:DigOut_ON2-SP";
monitor ch1_en_cmd; 

short ch2_en_cmd; 
assign ch2_en_cmd to "{M0}Chan2:DigOut_ON2-SP";
monitor ch2_en_cmd; 

short ch3_en_cmd; 
assign ch3_en_cmd to "{M0}Chan3:DigOut_ON2-SP";
monitor ch3_en_cmd; 

short ch4_en_cmd; 
assign ch4_en_cmd to "{M0}Chan4:DigOut_ON2-SP";
monitor ch4_en_cmd; 

short sum_fault; 
assign sum_fault to "{M0}{M1}:FaultsLat-I"; 
monitor sum_fault; 

/* stringout to display status or progress. */
string Chan_seq_messages;  
assign Chan_seq_messages to "{M0}{M1}_seq_messages";

int from_faulted_state; 

    /*******************************/
   /*    Initialization Phase     */
  /*******************************/
ss OFF_ON_FSM {

    state INIT_1 {
    	when(){
    	  flt_mask = 1; 
    	  pvPut(flt_mask); 
    	  DAC = 0; 
    	  pvPut(DAC); 
          ps_on_off_sts = 0;
          pvPut(ps_on_off_sts);
          Park = 1;
          pvPut(Park);
    	  on1_cmd = 0; 
	  pvPut(on1_cmd);  
          ch1_en_cmd = 1; 
          pvPut(ch1_en_cmd);  
          ch2_en_cmd = 1; 
          pvPut(ch2_en_cmd);  
          ch3_en_cmd = 1; 
          pvPut(ch3_en_cmd); 
          ch4_en_cmd = 1; 
          pvPut(ch4_en_cmd); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "WAIT...1");
          pvPut(Chan_seq_messages);
    	} state INIT_2
    }
    state INIT_2 {
    	when(delay(3)) {
          ch1_en_cmd = 1; 
          pvPut(ch1_en_cmd);  
          ch2_en_cmd = 1; 
          pvPut(ch2_en_cmd);  
          ch3_en_cmd = 1; 
          pvPut(ch3_en_cmd); 
          ch4_en_cmd = 1; 
          pvPut(ch4_en_cmd); 
          flt_mask = 0; 
    	  pvPut(flt_mask); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "WAIT....2");
          pvPut(Chan_seq_messages);
    	} state INIT_3
    }
    state INIT_3 {
    	when(delay(2)) {
          flt_mask = 1; 
    	  pvPut(flt_mask); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "WAIT.....3");
       	  pvPut(Chan_seq_messages);
    	} state INIT_4
    }
    state INIT_4 {
    	when(delay(2)) {
          flt_clr = 1; 
    	  pvPut(flt_clr); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "Clearing Faults");
       	  pvPut(Chan_seq_messages);
    	} state INIT_5
    }
    state INIT_5 {
    	when(delay(5)) {
          flt_clr = 0; 
    	  pvPut(flt_clr); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan_seq_messages, "Clear Done");
       	  pvPut(Chan_seq_messages);
    	} state CHECK_TYPE
    }
    state CHECK_TYPE {
        when(Polarity == 0) {
            printf("Initializing OFF_ON_FSM...\n");
            sprintf(Chan_seq_messages, "BIPOLAR");
       	    pvPut(Chan_seq_messages);
            Park = 1;
            pvPut(Park);
            printf("Set %s to 0\n", pvName(Park));
        } state BIPOLAR_IDLE
        when(Polarity == 1) {
            printf("Initializing OFF_ON_FSM...\n");
            sprintf(Chan_seq_messages, "UNIPOLAR");
       	    pvPut(Chan_seq_messages);
            Park = 1;
            pvPut(Park);
            printf("Set %s to 0\n", pvName(Park));
        } state UNIPOLAR_IDLE
    }
    
    /*******************************/
   /* Sequencer for Bipolar PSC   */
  /*******************************/
    state BIPOLAR_IDLE {
        when(ps_on_off == 1) {
		Park = 1; 
		pvPut(Park); 
		DAC = 0.0; 
		pvPut(DAC); 
		ps_on_off_sts = 0;
            	pvPut(ps_on_off_sts); 
            	sprintf(Chan_seq_messages, "Zero DAC");
       	    	pvPut(Chan_seq_messages);
       	    } state SET_DAC_TO_ZERO_ON
       	when(ps_on_off == 0) {
       	     if(from_faulted_state == 0) {
		//ps_on_off_sts = 1;
        	//pvPut(ps_on_off_sts); 
             } else {
                //ps_on_off_sts = 2;
        	//pvPut(ps_on_off_sts); 
             }
	        sprintf(Chan_seq_messages, "PS OFF");
       	    pvPut(Chan_seq_messages);
        } state CHECK_IF_SYSTEM_WAS_FAULTED
    }
        
    state CHECK_IF_SYSTEM_WAS_FAULTED {
    	when(from_faulted_state == 0){
    		ps_on_off_sts = 1;
        	pvPut(ps_on_off_sts); 
    	    } state BIPOLAR_IDLE
    	when(from_faulted_state == 1) { //System has previously faulted and we are retrying
    		from_faulted_state = 0; 
		Park = 1; 
		pvPut(Park); 
		DAC = 0.0; 
		pvPut(DAC); 
		ps_on_off_sts = 0;
            	pvPut(ps_on_off_sts); 
            	sprintf(Chan_seq_messages, "Zero DAC");
       	    	pvPut(Chan_seq_messages);    		
    	} state SET_DAC_TO_ZERO_ON
    }
    	
    state SET_DAC_TO_ZERO_ON {
		when ((DAC_rdbck < 0.01) && (DAC_rdbck > -0.01)) {
	        	sprintf(Chan_seq_messages, "Zeroing DAC");
	        	pvPut(Chan_seq_messages);  
	        	DAC =0.000; 
            		pvPut(DAC); 						
		} state CLEAR_FAULTS
    }    
    
    state CLEAR_FAULTS {
		when (delay(2)) {
			sprintf(Chan_seq_messages, "Clear Faults");
			pvPut(Chan_seq_messages); 
			flt_clr = 1; 
			pvPut(flt_clr); 
			ch1_en_cmd = 1; 
          		pvPut(ch1_en_cmd);  
          		ch2_en_cmd = 1; 
          		pvPut(ch2_en_cmd);  
          		ch3_en_cmd = 1; 
          		pvPut(ch3_en_cmd); 
          		ch4_en_cmd = 1; 
          		pvPut(ch4_en_cmd); 						
		} state WAIT_TO_CLEAR
	}
	state WAIT_TO_CLEAR {
		when (delay(5)) {
			sprintf(Chan_seq_messages, "Clearing");
			pvPut(Chan_seq_messages); 
			flt_clr = 0; 
			pvPut(flt_clr); 						
		} state POWER_ON
	}	
    	state POWER_ON {
    		when(delay(2)){
    	   		on1_cmd = 1; 
	   		pvPut(on1_cmd); 
	   		sprintf(Chan_seq_messages, "Powering ON");
	   		pvPut(Chan_seq_messages); 
    		} state PARK_OFF
    	}		
	state PARK_OFF {
		when (delay(8)) {
			sprintf(Chan_seq_messages, "Park OFF");
			pvPut(Chan_seq_messages); 
			Park = 0; 
			pvPut(Park); 						
		} state DONE_CHECK
	}
	state DONE_CHECK{
		when (ps_on_sts == 0) {	
			from_faulted_state = 1; 
			ps_on_off_sts = 0;	
			pvPut(ps_on_off_sts); 				
		} state RETRY_ON
		when (ps_on_sts == 1) {				
		} state DONE
	}
	state RETRY_ON {
		when (ps_on_off==0) {
			ps_on_off_sts = 2; 
			pvPut(ps_on_off_sts); 
			sprintf(Chan_seq_messages, "Faulted..Try Again");
        		pvPut(Chan_seq_messages);
        	    } state RETRY_ON
        	when (ps_on_off==1) {
        		ps_on_off_sts = 2; 
			pvPut(ps_on_off_sts);
			on1_cmd = 0; 
			pvPut(on1_cmd); 
        		sprintf(Chan_seq_messages, "Faulted..Try Again");
        		pvPut(Chan_seq_messages);
        	    } state INIT_1 
	}
	state DONE {
		when (delay(1)) {
			sprintf(Chan_seq_messages, "PS Ready!");
			pvPut(Chan_seq_messages); 	
			ps_on_off_sts = 1;	
			pvPut(ps_on_off_sts); 				
		} state READY
	}
	state READY {
		when (ps_on_off==1) {
			sprintf(Chan_seq_messages, "Zero DAC");
        	   	pvPut(Chan_seq_messages);
        	   	DAC =0.00; 
        	   	pvPut(DAC); 
        	   	ps_on_off_sts = 0;
        	   	pvPut(ps_on_off_sts); 
		} state SET_DAC_TO_ZERO_OFF
		when(ps_on_off==0) {
        	   	ps_on_off_sts = 1;
        	   	pvPut(ps_on_off_sts); 
			sprintf(Chan_seq_messages, " PS Ready!");
        	   	pvPut(Chan_seq_messages);
		} state CHECK_FAULT
	}
	state CHECK_FAULT {
		when(sum_fault == 0){
		} state READY
		when(sum_fault > 0) {
			from_faulted_state = 1; 
			ps_on_off_sts = 2; 
			pvPut(ps_on_off_sts); 
			sprintf(Chan_seq_messages, "Fault"); 
		} state RETRY_ON
	}
	state SET_DAC_TO_ZERO_OFF {
		when ((DAC_rdbck < 0.01) && (DAC_rdbck > -0.05)) {
			sprintf(Chan_seq_messages, "Turning OFF");
			pvPut(Chan_seq_messages);  						
		} state POWER_OFF
	}
	state POWER_OFF {
		when (delay(5)) {
			sprintf(Chan_seq_messages, "Turning OFF");
			pvPut(Chan_seq_messages); 
			on1_cmd = 0; 
			pvPut(on1_cmd); 	
			Park = 0; 
			pvPut(Park); 					
		} state COMPLETE
	}
	state COMPLETE {
		when (delay(1)) {
			sprintf(Chan_seq_messages, "Power OFF");
			pvPut(Chan_seq_messages); 
			ps_on_off_sts = 1;
			pvPut(ps_on_off_sts); 				
		} state BIPOLAR_IDLE
	}
  
    /*******************************/
   /* Sequencer for Unipolar PSC  */
  /*******************************/
    state UNIPOLAR_IDLE {
        when(delay(1.0)) {
            printf("Set %s to 1\n", pvName(Park));
            sprintf(Chan_seq_messages, "IDLE 2CH");
       	    pvPut(Chan_seq_messages);
        } state UNIPOLAR_IDLE
    }
}

