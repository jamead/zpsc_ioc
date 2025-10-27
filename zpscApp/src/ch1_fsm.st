/* Sequencer to control the on-demond record process: ramping table download, power supply mode change, and watch funciton upload */

#define PRINTF seqLog

program ch1_fsm ("M0=lab{3}, M1=Chan1")


/* ============================================================
   Options
   ------------------------------------------------------------
   +r : Reentrant (allows multiple instances)
   -c : Do not wait for all assigned PVs to connect at startup
   ============================================================ */
option +r;
option -c;

/* ============================================================
   Write-only Process Variables
   ------------------------------------------------------------
   'Park' is a binary output (bo) record such as:
   record(bo, "lab3Chan1:DigOut_Park-SP") { ... }
   ============================================================ */
short DAC; 
assign DAC to "{M0}{M1}:DAC_SetPt-SP"; 
monitor DAC; 

short DAC_rdbck; 
assign DAC_rdbck to "{M0}{M1}:DAC-I"; 
monitor DAC_rdbck; 

short Park;
assign Park to "{M0}{M1}:DigOut_Park-SP";
monitor Park;

short NumChans; 
assign NumChans to "{M0}NumChannels-Mode"; 
monitor NumChans; 

short flt_mask; 
assign flt_mask to "{M0}{M1}:FaultMask:B12-SP"; 
monitor flt_mask; 

short flt_clr; 
assign flt_clr to "{M0}{M1}:FaultClear-SP"; 
monitor flt_clr; 

short ps_on_off; 
assign ps_on_off to "{M0}{M1}:PSOnOff-SP"; 
monitor ps_on_off; 

/* stringout to display status or progress. */
string Chan1_seq_messages;  assign Chan1_seq_messages to "Chan1_seq_messages";

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
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan1_seq_messages, "INIT 1");
          pvPut(Chan1_seq_messages);
    	} state INIT_2
    }
    state INIT_2 {
    	when(delay(2)) {
          flt_mask = 0; 
    	  pvPut(flt_mask); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan1_seq_messages, "INIT 2");
          pvPut(Chan1_seq_messages);
    	} state INIT_3
    }
    state INIT_3 {
    	when(delay(2)) {
          flt_mask = 1; 
    	  pvPut(flt_mask); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan1_seq_messages, "INIT 3");
       	  pvPut(Chan1_seq_messages);
    	} state INIT_4
    }
    state INIT_4 {
    	when(delay(2)) {
          flt_clr = 1; 
    	  pvPut(flt_clr); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan1_seq_messages, "Clearing Faults");
       	  pvPut(Chan1_seq_messages);
    	} state INIT_5
    }
    state INIT_5 {
    	when(delay(5)) {
          flt_clr = 0; 
    	  pvPut(flt_clr); 
    	  printf("Initializing OFF_ON_FSM...\n");
          sprintf(Chan1_seq_messages, "Clear Done");
       	  pvPut(Chan1_seq_messages);
    	} state CHECK_CHANS
    }
    state CHECK_CHANS {
        when(NumChans == 1) {
            printf("Initializing OFF_ON_FSM...\n");
            sprintf(Chan1_seq_messages, "INIT 4CH");
       	    pvPut(Chan1_seq_messages);

            /* Set PV to 0 initially */
            Park = 1;
            pvPut(Park);
            printf("Set %s to 0\n", pvName(Park));
        } state IDLE_4CH
        when(NumChans == 0) {
            printf("Initializing OFF_ON_FSM...\n");
            sprintf(Chan1_seq_messages, "INIT 2CH");
       	    pvPut(Chan1_seq_messages);

            /* Set PV to 0 initially */
            Park = 1;
            pvPut(Park);
            printf("Set %s to 0\n", pvName(Park));
        } state IDLE_2CH
    }
    
    /*******************************/
   /* Sequencer for 4 Channel PSC */
  /*******************************/
    state IDLE_4CH {
        when(ps_on_off == 1) {
	    Park = 1; 
	    pvPut(Park); 
	    DAC = 0.0; 
	    pvPut(DAC); 
            sprintf(Chan1_seq_messages, "Zero DAC");
       	    pvPut(Chan1_seq_messages);
       	    } state SET_DAC_TO_ZERO_ON
       	when(ps_on_off == 0) {
            //Park = 1; 
	    //pvPut(Park); 
	    sprintf(Chan1_seq_messages, "IDLE");
       	    pvPut(Chan1_seq_messages);
        } state IDLE_4CH
    }
    state SET_DAC_TO_ZERO_ON {
	when ((DAC_rdbck < 0.01) && (DAC_rdbck > -0.01)) {
	    sprintf(Chan1_seq_messages, "Zeroing DAC");
	    pvPut(Chan1_seq_messages);  
	    DAC =0.000; 
            pvPut(DAC); 						
	} state POWER_ON
    }    
    state POWER_ON {
    	when(){
	   sprintf(Chan1_seq_messages, "Powering ON");
	   pvPut(Chan1_seq_messages); 
    	} state POWER_ON
    }
    
    /*******************************/
   /* Sequencer for 2 Channel PSC */
  /*******************************/
    state IDLE_2CH {
        when(delay(1.0)) {
            printf("Set %s to 1\n", pvName(Park));
            sprintf(Chan1_seq_messages, "IDLE 2CH");
       	    pvPut(Chan1_seq_messages);
        } state IDLE_2CH
    }
}

