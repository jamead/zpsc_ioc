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

/* stringout to display status or progress. */
string Chan1_seq_messages;  assign Chan1_seq_messages to "Chan1_seq_messages";

/* ============================================================
   State Set Definition
   ============================================================ */
ss OFF_ON_FSM {

    state INIT_1 {
    	when(){
    	  flt_mask = 1; 
    	  pvPut(flt_mask); 
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
    	} state INIT_5
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
            Park = 0;
            pvPut(Park);
            printf("Set %s to 0\n", pvName(Park));
        } state IDLE_2CH
    }
    
    /*******************************/
   /* Sequencer for 4 Channel PSC */
  /*******************************/
    state IDLE_4CH {
        when (delay(1.0)) {
            /* Only write if value actually changes */
            if (Park != 1) {
                Park = 1;
                pvPut(Park);
                printf("Set %s to 1\n", pvName(Park));
                sprintf(Chan1_seq_messages, "IDLE 4CH");
       	    	pvPut(Chan1_seq_messages);
            } else {
                printf("%s is already 1\n", pvName(Park));
                sprintf(Chan1_seq_messages, "IDLE 4CH");
       	    	pvPut(Chan1_seq_messages);
            }
        } state IDLE_4CH
    }
    
    /*******************************/
   /* Sequencer for 2 Channel PSC */
  /*******************************/
    state IDLE_2CH {
        when (delay(1.0)) {
            /* Only write if value actually changes */
            if (Park != 1) {
                Park = 1;
                pvPut(Park);
                printf("Set %s to 1\n", pvName(Park));
                sprintf(Chan1_seq_messages, "IDLE 2CH");
       	    	pvPut(Chan1_seq_messages);
            } else {
                printf("%s is already 1\n", pvName(Park));
                sprintf(Chan1_seq_messages, "IDLE 2CH");
       	    	pvPut(Chan1_seq_messages);
            }
        } state IDLE_2CH
    }
}

