// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_flutter_fire/app/modules/persona/persona_controller.dart';
// import 'package:get_flutter_fire/app/modules/settings/controllers/settings_controller.dart';

// class PersonaSelectionView extends GetView<SettingsController> {
//   const PersonaSelectionView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           ListTile(
//             title: Text('Default Theme'),
//             trailing: Icon(Icons.check_circle_outline),
//             onTap: () => controller.setPersona(null),
//           ),
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(16),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemCount: customPersonas.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () => controller.setPersona(customPersonas[index]),
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     color: customPersonas[index].backgroundColor,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/${customPersonas[index].name}.png',
//                           width: 48,
//                           height: 48,
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           customPersonas[index].name,
//                           style: TextStyle(
//                             color: customPersonas[index].textColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_flutter_fire/app/modules/persona/persona_controller.dart';
import 'package:get_flutter_fire/app/modules/settings/controllers/settings_controller.dart';

class PersonaSelectionView extends GetView<SettingsController> {
  const PersonaSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Persona')),
      body: Column(
        children: [
          Obx(() => SwitchListTile(
            title: Text('Dark Mode'),
            value: controller.isDarkMode.value,
            onChanged: (value) => controller.toggleDarkMode(),
          )),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: customPersonas.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => controller.setPersona(customPersonas[index]),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: customPersonas[index].gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/${customPersonas[index].name.toLowerCase()}.png',
                            width: 48,
                            height: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            customPersonas[index].name,
                            style: TextStyle(
                              color: customPersonas[index].textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Obx(() => IconButton(
                            icon: Icon(
                              controller.selectedPersona.value?.name == customPersonas[index].name
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: customPersonas[index].textColor,
                            ),
                            onPressed: () => controller.togglePersona(customPersonas[index]),
                          )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}