<?php

namespace App\Filament\Resources\Memorials;

use App\Filament\Resources\Memorials\Pages\CreateMemorial;
use App\Filament\Resources\Memorials\Pages\EditMemorial;
use App\Filament\Resources\Memorials\Pages\ListMemorials;
use App\Filament\Resources\Memorials\Schemas\MemorialForm;
use App\Filament\Resources\Memorials\Tables\MemorialsTable;
use App\Models\Memorial;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class MemorialResource extends Resource
{
    protected static ?string $model = Memorial::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedBookOpen;

    protected static ?string $recordTitleAttribute = 'full_name';

    protected static ?string $navigationLabel = 'Dossiers';

    protected static ?int $navigationSort = 1;

    public static function form(Schema $schema): Schema
    {
        return MemorialForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return MemorialsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListMemorials::route('/'),
            'create' => CreateMemorial::route('/create'),
            'edit' => EditMemorial::route('/{record}/edit'),
        ];
    }
}
