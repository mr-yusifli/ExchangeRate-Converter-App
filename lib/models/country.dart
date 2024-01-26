class Country {
  late String name;
  late String urlFlag;
  late String currency;

  Country({required this.name, required this.urlFlag, required this.currency});
}

final List<Country> datas = [
  Country(
    name: 'USA',
    urlFlag:
        'https://cdn.countryflags.com/thumbs/united-states-of-america/flag-round-250.png',
    currency: 'USD',
  ),
  Country(
    name: 'EUR',
    urlFlag: 'https://cdn.countryflags.com/thumbs/europe/flag-round-250.png',
    currency: 'EUR',
  ),
  Country(
    name: 'AZE',
    urlFlag:
        'https://cdn.countryflags.com/thumbs/azerbaijan/flag-round-250.png',
    currency: 'AZN',
  ),
  Country(
    name: 'RUS',
    urlFlag: 'https://cdn.countryflags.com/thumbs/russia/flag-round-250.png',
    currency: 'RUB',
  ),
  Country(
    name: 'TUR',
    urlFlag: 'https://cdn.countryflags.com/thumbs/turkey/flag-round-250.png',
    currency: 'TRY',
  ),
];
