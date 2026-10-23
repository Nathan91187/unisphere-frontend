import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_sphere/features/clubs/domain/entities/club_category.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_bloc.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_event.dart';
import 'package:uni_sphere/features/clubs/presentation/bloc/club_state.dart';
import 'package:uni_sphere/features/clubs/presentation/pages/club_details_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/unableToConnect.dart';
import '../../domain/entities/club.dart';

class ClubsPage extends StatefulWidget {
  const ClubsPage({super.key});

  @override
  State<ClubsPage> createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  String selectedCategory = '';
  final textPrimary = AppColors.primaryText;
  final textSecondary = AppColors.secondaryText;
  final primary = AppColors.primary;
  final secondary = AppColors.secondary;
  final surface = AppColors.surface;
  final searchController = TextEditingController();
  List<Club> _filterClubs(List<Club> clubs) {
    final query = searchController.text.trim().toLowerCase();

    return clubs.where((club) {
      final matchesCategory = selectedCategory.isEmpty || //if no category is selected every event passes the filter
          club.category.name == selectedCategory; //if the selected category is the same as current events category

      final matchesName = club.name.toLowerCase().contains(query); // if the current event contains the search text in any part of it

      return matchesCategory && matchesName;
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: Text("Clubs"),
        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Form(
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value){
                          setState(() {
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search clubs",
                          fillColor: colors.surface,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.search,
                            color: primary.withValues(alpha: .8),
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                          )
                              : null,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: primary
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: textPrimary.withValues(alpha: .3)
                              )
                          ),
                        ),
                      )),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...ClubCategory.values.map((value){
                          final name = value.name;
                          final isSelected = selectedCategory == value.name;
                          final buttonColor = isSelected
                              ? primary
                              : colors.secondary.withValues(alpha: 0.30);
                          final textColor = isSelected ? surface : colors.primary;
                          return Row(
                            children: [
                              TextButton(
                                onPressed: (){
                                  setState(() {
                                    if(selectedCategory == value.name){
                                      selectedCategory = '';
                                    }
                                    else{
                                      selectedCategory = value.name;
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: buttonColor
                                ),
                                child: Text(
                                  name.toUpperCase(),
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              SizedBox(width: 5)
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<ClubBloc,ClubState>(
                      builder: (context,state){
                        if(state is ClubLoading){
                          return Center(
                            child: Loading(),
                          );
                        }
                        if(state is ClubError){
                          return unableToConnectWidget(state.errorMsg, ()=>context.read<ClubBloc>().add(LoadClubs()));
                        }
                        if(state is ClubLoaded){
                          final clubs =  _filterClubs(state.clubs);
                          if(clubs.isEmpty){
                            return Center(
                              child: Text(
                                  "No Clubs"
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: clubs.length,
                            itemBuilder: (context,index)=>
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: textSecondary.withValues(alpha: 0.20),
                                        width: 0.5
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  color: colors.surface,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context)=> ClubDetailsPage(club: clubs[index])));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                      child: Column(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: ClipRRect(
                                              borderRadius: BorderRadiusGeometry.circular(10),
                                              child: Image.asset(
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: 500,
                                                  "assets/images/ronaldo_crying.png"
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                                        decoration: BoxDecoration(
                                                            color: colors.secondary.withValues(alpha: 0.30),
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        child: Text(
                                                          clubs[index].category.name.toUpperCase(),
                                                          style: TextStyle(
                                                              color: colors.primary,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 3,),
                                                      Text(
                                                        clubs[index].name,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            overflow: TextOverflow.ellipsis,
                                                            color: textPrimary,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        clubs[index].description,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: textSecondary,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.people,
                                                            color: textSecondary,
                                                            size: 15,
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Expanded(
                                                            child: Text(
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                "${clubs[index].memberCount.toString()} members",
                                                                style: TextStyle(
                                                                  color: textSecondary,
                                                                  fontWeight: FontWeight.w500
                                                                )
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                              Icon(
                                                Icons.chevron_right,
                                                color: textSecondary,
                                                size: 22,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          );}
                        return SizedBox.shrink();
                      }
                  )
                ],
              ),
            )
        )
    );
  }
}
