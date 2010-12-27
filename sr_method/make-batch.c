/* make-batch.c */
#include <stdio.h>

void	printValue(char *fn1)
{
  FILE            *fp;
  int             i, j, alpha;

  alpha = 100;

  fp = fopen(fn1, "w");

/***************************************
フォルダ作成およびlabel-listの作成
****************************************/

  fprintf(fp,"mkdir Wiki\n");
  fprintf(fp,"mkdir Wiki/core_wiki\n");
  fprintf(fp,"mkdir Wiki/group_sr\n");
  for(i = 0; i < 101; i++){
    fprintf(fp,"mkdir Wiki/core_wiki/core_%d\n",i+1);
  }
  fprintf(fp,"cp label-list.wiki2 Wiki/core_wiki/label-list_wiki_sr\n");

  
  fprintf(fp,"mkdir Blog\n");
  fprintf(fp,"mkdir Blog/core_blog\n");
  fprintf(fp,"mkdir Blog/group_sr\n");
  for(i = 0; i < 101; i++){
    fprintf(fp,"mkdir Blog/core_blog/core_%d\n",i+1);
  }
  fprintf(fp,"cp label-list034_interactive Blog/core_blog/label-list034_interactive_sr\n");
  
  
/*****************************************
SRコア抽出(Wiki)
*********************************************/
  for(i = 0; i < 100; i++){
    fprintf(fp,"./sr_method Wiki/core_wiki/label-list_wiki_sr Wiki/core_wiki/core_%d/node_%d\n", i+1,i+1);
//    fprintf(fp,"./make_namelist Wiki/core_wiki/core_%d/node_%d URLID.wiki2 Wiki/core_wiki/core_%d/Name-list_%d\n", i+1, i+1, i+1, i+1);
    fprintf(fp,"./select_core Wiki/core_wiki/core_%d/node_%d Wiki/core_wiki/label-list_wiki_sr Wiki/core_wiki/label-list_wiki_sr\n", i+1, i+1);
  }
/******************************************
SRコアグループ作成(Wiki)
**********************************************/
  fprintf(fp,"./init_grouplist 9481 Wiki/group_sr/grouplist_sr_0\n");
  for(i = 0; i < 100; i++){
    fprintf(fp,"./make_grouplist Wiki/group_sr/grouplist_sr_%d Wiki/core_wiki/core_%d/node_%d Wiki/group_sr/grouplist_sr_%d\n",i, i+1, i+1, i+1);
  }

/*****************************************
SRコア抽出(Blog)
 *********************************************/
  for(i = 0; i < 100; i++){
    fprintf(fp,"./sr_method Blog/core_blog/label-list034_interactive_sr Blog/core_blog/core_%d/node_%d\n", i+1,i+1);
//    fprintf(fp,"./make_namelist Blog/core_blog/core_%d/node_%d URLID034 Blog/core_blog/core_%d/Name-list_%d\n", i+1, i+1, i+1, i+1);
    fprintf(fp,"./select_core Blog/core_blog/core_%d/node_%d Blog/core_blog/label-list034_interactive_sr Blog/core_blog/label-list034_interactive_sr\n", i+1, i+1);
  }
/******************************************
SRコアグループ作成(Blog)
**********************************************/
  fprintf(fp,"./init_grouplist 12047 Blog/group_sr/grouplist_sr_0\n");
  for(i = 0; i < 100; i++){
    fprintf(fp,"./make_grouplist Blog/group_sr/grouplist_sr_%d Blog/core_blog/core_%d/node_%d Blog/group_sr/grouplist_sr_%d\n",i, i+1, i+1, i+1);
  }

  /***************convert_grouplist_sr********************************/
  fprintf(fp,"./convert_grouplist_sr Blog/group_sr/grouplist_sr_100 Blog/group_sr/grouplist_101\n");
  fprintf(fp,"./convert_grouplist_sr Wiki/group_sr/grouplist_sr_100 Wiki/group_sr/grouplist_101\n");
  /******************************************************/
 
  fclose(fp); 
}

main(int argc, char **argv)
{
  printValue(argv[1]);
}
