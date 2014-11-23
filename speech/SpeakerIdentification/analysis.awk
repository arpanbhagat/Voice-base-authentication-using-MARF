BEGIN{
	numtest=0;
	matc=0;
	flag=0;
}
{
	if($1!~/Done/)
	{
		if($1~/Config:/)
		{
#			printf("Total No Of Match : %d",matc);
#			printf("\nTotal No of Tests : %d",numtest);
			if(flag!=0)				
				printf("  Accuracy:  %f\n",(float)matc/numtest);

			if(flag==0)
			{
				flag=1;
			}
#			printf("\n=====================================================\n")
			printf("%s",$0);
			matc=0;
			numtest=0;
		}
		else
		{
			numtest++;
#		print $1,$2
			if($1~$2)	
				matc++;					      }	
	}
}
END{
#	printf("Total No Of Match : %d",matc);
#        printf("\nTotal No of Tests : %d",numtest);
        printf("  Accuracy:  %f\n",(float)matc/numtest);
#        printf("\n=====================================================\n\n")
}
