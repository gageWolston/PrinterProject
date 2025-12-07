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
    'Color',
    'Black & White',
    'Fax',
    'Copier',
    'Scanner',
    'Laser',
    'Inkjet',
    'Dot Matrix',
    'Brand: HP',
    'Brand: Canon',
    'Brand: Epson',
    'Budget (<\$200)',
    'Midrange (\$200-\$400)',
    'Premium (\$400+)'
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
                    if (selected) {
                      selectedFilters.add(filter);
                    } else {
                      selectedFilters.remove(filter);
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
