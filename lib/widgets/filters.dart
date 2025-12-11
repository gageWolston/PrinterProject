import 'package:flutter/material.dart';

class FilterList extends StatefulWidget {
  final Function(Set<String>) onFiltersChanged;
  const FilterList({super.key, required this.onFiltersChanged});

  @override
  FiltersListState createState() => FiltersListState();
}

class FiltersListState extends State<FilterList> {
  final List<String> filters = [
    'All Printers',
    'On Sale',
    'Laser',
    'Inkjet',
    'Dot Matrix',
    'Color',
    'Black & White',
    'Fax',
    'Copier',
    'Scanner',
  ];

  final Set<String> selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = selectedFilters.contains(filter);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (filter == 'All Printers') {
                      if (selected) {
                        selectedFilters
                          ..clear()
                          ..add(filter);
                      } else {
                        selectedFilters.remove(filter);
                      }
                    } else {
                      if (selected) {
                        selectedFilters
                          ..remove('All Printers')
                          ..add(filter);
                      } else {
                        selectedFilters.remove(filter);
                      }
                    }
                  });
                  widget.onFiltersChanged(selectedFilters);

                  debugPrint('Active filters: $selectedFilters');
                },
                selectedColor: Colors.blue.shade200,
                showCheckmark: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
