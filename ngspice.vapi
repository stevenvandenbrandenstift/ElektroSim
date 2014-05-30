[CCode (cheader_filename = "/home/steven/projecten/ElektroSimgit/ElektroSim/sharedspice.h")]
namespace ngspice {
	
	[CCode (cname = "ngcomplex", has_destroy_function = false, has_copy_function = false, 			has_type_id = false)]
	public struct NgComplex { 
		public double cx_real;		/* real part */
    		public int cx_imag;		/* imaginair part */
	}
	

	[CCode (cname = "vector_info", has_destroy_function = false, has_copy_function = false, 		has_type_id = false)]
	/* vector info obtained from any vector in ngspice.dll.
   	Allows direct access to the ngspice internal vector structure,
   	as defined in include/ngspice/devc.h . */
	public struct VectorInfo {
		[CCode (cname = "v_name")]
		public unowned string name;		/* Same as so_vname. */
		[CCode (cname = "v_type")]    		
		public int type;			/* Same as so_vtype. */
		[CCode (cname = "v_flags")]    		
		public short flags;		/* Flags (a combination of VF_*). */
   		[CCode (cname = "v_realdata")] 
		public double data; 		/* Real data. */
		[CCode (cname = "v_compdata")]  
    		public NgComplex data_complex;	/* Complex data. */
		[CCode (cname = "v_length")]
    		public int length;		/* Length of the vector. */

	}//vector_info, *pvector_info;
	[CCode (cname = "vecvalues", has_destroy_function = false, has_copy_function = false, 		has_type_id = false)]
	public struct VecValues {
    		public string name;        /* name of a specific vector */
    		public double creal;      /* actual data value */
    		public double cimag;      /* actual data value */
    		public bool is_scale;     /* if 'name' is the scale vector */
    		public bool is_complex;   /* if the data are complex numbers */
	} 	//vecvalues, *pv	ecvalues;

	[CCode (cname = "vecvaluesall", has_destroy_function = false, has_copy_function = false, 		has_type_id = false)]
	public struct VecValuesAll {
    		public int veccount;      /* number of vectors in plot */
   		public int vecindex;      /* index of actual set of vectors. i.e. the number of 		accepted data points */
		[CCode (cname = "vecsa",array_length = false)]
    		public VecValues[] actualSetValues; /* values of actual set of vectors, indexed from 0 to veccount - 1 */
	} 	//vecvaluesall, *pvecvaluesall;

	/* info for a specific vector */
	[CCode (cname = "vecinfo", has_destroy_function = false, has_copy_function = false, 		has_type_id = false)]
	public struct VecInfo {
	    public int number;     /* number of vector, as postion in the linked list of vectors, starts with 0 */
	    public unowned string vecname;  /* name of the actual vector */
	    public bool is_real;   /* TRUE if the actual vector has real data */
	    public VectorInfo pdvec;    /* a void pointer to struct dvec *d, the actual vector */
	    public VectorInfo pdvecscale; /* a void pointer to struct dvec *ds, the scale vector */
	} 	//vecinfo, *pvecinfo;
	
	/* info for the current plot */
	[CCode (cname = "vecinfoall", has_destroy_function = false, has_copy_function = false, 		has_type_id = false)]
	public struct VecInfoAll {
	     /* the plot */
	    public unowned string name;
	    public unowned string title;
	    public unowned string date;
	    public unowned string type;
	    public int veccount;
		
	   /* the data as an array of vecinfo with length equal to the number of vectors in the plot 			*/
    	[CCode (array_length = false)]	
	   public VecInfo[] vecs;

	} //vecinfoall, *pvecinfoall;


	/* callback functions
	addresses received from caller with ngSpice_Init() function
	*/
	/* sending output from stdout, stderr to caller */
	[CCode (cname = "SendChar", simple_generics= true, has_target = false)]
		public delegate int SendOutput<T> (string sendToCaller, int  id, T data);
/*
   		sendToCaller string to be sent to caller output
   		id   identification number of calling ngspice shared lib
*/
	/* sending simulation status to caller */
	[CCode (cname = "SendStat", simple_generics = true, has_target = false)]
	public delegate int SendSimulationStatus<T> ( string simulationStatus, int id, T data);
	/*
	   simulationStatus	 simulation status and value (in percent) to be sent to caller
	   id  identification number of calling ngspice shared lib
	*/
	/* asking for controlled exit */
	[CCode (cname = "ControlledExit", simple_generics = true, has_target = false)]
	public delegate int ControlledExit<T> (int status, bool unloadImmediate, bool exitOnQuit,int id, T data);
	/*
	   status   exit status
	   unloadImmediate  if true: immediate unloading dll, if false: just set flag, unload is done when function has returned
	   exitOnQuit  if true: exit upon 'quit', if false: exit due to ngspice.dll error
	   id   identification number of calling ngspice shared lib
	*/

	/* send back actual vector data */
	[CCode (cname = "SendData", simple_generics = true, has_target = false)]
	public delegate int  SendVectorData<T>([CCode (array_length = false)]VecValuesAll[] allVectors , int amount, int id, T data);
	/*
	   allVectors pointer to array of structs containing actual values from all vectors
	   amount           number of structs (one per vector)
	   id           identification number of calling ngspice shared lib
	*/

	/* send back initailization vector data */
	[CCode (cname = "SendInitData", simple_generics = true, has_target = false)]
	public delegate int SendInitializationData<T>([CCode (array_length = false)] VecInfoAll[] vecs, int id,T data);
	/*
	   vecinfoall pointer to array of structs containing data from all vectors right after initialization
	   id         identification number of calling ngspice shared lib
	*/

	/* indicate if background thread is running */
	[CCode (cname = "BGThreadRunning", simple_generics = true, has_target = false)]
	public delegate int  IsBackgroundThreadRunning<T>(bool running, int id, T data);
	/*
	   running        true if background thread is running
	   id         identification number of calling ngspice shared lib
	*/

	/* callback functions
	   addresses received from caller with ngSpice_Init_Sync() function
	*/

	/* ask for VSRC EXTERNAL value */
	[CCode (cname = "GetVSRCData", simple_generics = true, has_target = false)]
	public delegate int GetVSRCData<T>(double voltage, double time, string name, int id, T data);
	/*
	   voltage     return voltage value
	   time      actual time
	   name      node name
	   id         identification number of calling ngspice shared lib
	*/

	/* ask for ISRC EXTERNAL value */
	[CCode (cname = "GetISRCData", simple_generics = true, has_target = false)]
	public delegate int GetISRCData<T>(double current, double time, string name, int id, T data);
	/*
	   current     return current value
	   time      actual time
	   name       node name
	   id         identification number of calling ngspice shared lib
	*/

	/* ask for new delta time depending on synchronization requirements */
	[CCode (cname = "GetSyncData", simple_generics = true, has_target = false)]
	public delegate int GetSyncData<T>(double time, double delta, double oldDelta, int redoStep, int id, int syncLocationDctran,T data);
	/*
	   time      actual time (ckt->CKTtime)
	   delta    delta time (ckt->CKTdelta)
	   oldDelta      old delta time (olddelta)
	   redoStep         redostep (as set by ngspice)
	   id         identification number of calling ngspice shared lib
	   syncLocationDctran         location of call for synchronization in dctran.c
	*/


			
		[CCode (cname = "ngSpice_Init",simple_generics = true)]
		public static int init<T>(SendOutput<T>? a, SendSimulationStatus<T>? b, ControlledExit<T>? c,  SendVectorData<T>? d,  SendInitializationData<T>? e, 				IsBackgroundThreadRunning<T>? f, T data);
		
		[CCode (cname = "ngSpice_Init_Sync")]
		public static int init_sync<T>( GetVSRCData<T>? g, GetISRCData<T>? h, GetSyncData<T>? i
		, int identificationLibrary, T userData); 	
			   
		[CCode (cname = "ngSpice_Command")]
		public int send_command(string command);

		[CCode (cname = "ngGet_Vec_Info")]
		public int get_vector_info(string vector_name);
		
		[CCode (cname = "ngSpice_Circ")]
		public int upload_circuit([CCode (array_length = false)]string[] netlist);
		
		[CCode (cname = "ngSpice_CurPlot")]
		public string get_current_plot_name();

		[CCode (cname = "ngSpice_AllPlots")]
		public string[] get_all_plot_names();

		[CCode (cname = "ngSpice_AllVecs")]
		public string[] get_all_vectors_of_plot(string plotname);
		
		[CCode (cname = "ngSpice_running")]
		public bool is_running();

		[CCode (cname = "ngSpice_SetBkpt")]
		public bool set_breakpoint(double time);
	
}
